require "MyNode"
require "AcyclicSP"

class HomeController < ApplicationController

  attr_accessor :node_list, :dwell_arcs, :train_arcs, :acyclic_sp

  def index
    create_nodes if Node.all.empty? && NodeDetail.all.empty?
    create_dwell_arcs if Arc.find_by_arc_type("Dwell").nil?
    create_train_arcs if Arc.find_by_arc_type("Train").nil?
    #@acyclic_sp = AcyclicSP.new @node_list
    #@acyclic_sp.create_outbound_arcs @dwell_arcs, @train_arcs
  end

  def create_nodes
    # First empty all nodes
    @node_list = {}
    node_id = 1
    TrainRoute.all(:include => :train).each do |tr|
      event_time = tr.arrive_time_hhhmm unless (tr.arrive_time_hhhmm == -1)
      event_time = tr.depart_time_hhhmm if event_time.nil? 
      (1..21).each do |d|
        schedule_index = 1 if (d == 15)
        schedule_index = d % 15 if schedule_index.nil?
        train_operating =  tr.train["operates_day_#{schedule_index}"] unless tr.train.nil?
        if train_operating  
          computed_minutes = event_time + ((d-1) * 1440)
          computed_hhhmm = "#{(computed_minutes/60).to_s.rjust(3,"0")}#{(computed_minutes % 60).to_s.rjust(2,"0")}"
          node_key = "#{tr.station_num.to_s.rjust(5,"0")}#{computed_minutes.to_s.rjust(6,"0")}"
          new_node = MyNode.new node_id, computed_minutes, tr.station_num, tr.station_name, event_time
          @node_list[node_key] = new_node      
          node_id =+ 1
        end
      end
    end
    logger.debug "Node list size is #{@node_list.size}"
    @node_list.keys.sort.each do |p|
      Node.create(:station_num => @node_list[p].station_num, :event_time => @node_list[p].event_time)
      NodeDetail.create(
        :station_num => @node_list[p].station_num, 
        :station_name => @node_list[p].station_name, 
        :event_time => @node_list[p].event_time,
        :original_event_time => @node_list[p].original_event_time
      )
    end
    logger.debug "Node table size is #{Node.all.size}"
  end     
  
  def create_dwell_arcs
    # Join node list against Train Route
    current_station_num = 0
    previous_station_num = 0
    from_node = 0
    to_node = 0 
    from_time = 0
    to_time = 0
    nodes_with_train_routes = NodeDetail.joins("INNER JOIN train_routes " +
      "ON node_details.station_num = train_routes.station_num " +
      "AND node_details.station_name = train_routes.station_name AND " +
      "( (train_routes.arrive_time_hhhmm = -1 AND train_routes.depart_time_hhhmm = original_event_time) " +
      "OR (train_routes.depart_time_hhhmm = -1 AND train_routes.arrive_time_hhhmm = original_event_time))")
      .select("node_details.station_num, node_details.station_name, node_details.event_time, node_details.id")
      .order("node_details.station_num, node_details.station_name, node_details.event_time").all
    logger.debug "Nodes with train data has #{nodes_with_train_routes.size} rows"  
    nodes_with_train_routes.each do |t|
      if current_station_num == 0 && previous_station_num == 0 
        from_node = t.id
        logger.debug "From Node = #{from_node}"
        previous_station_num = t.station_num
        from_time = t.event_time
        next
      end
      current_station_num = t.station_num
      if current_station_num == previous_station_num
        to_node = t.id
        to_time = t.event_time
        time_difference = to_time - from_time unless from_time.nil?
        logger.debug "From Node = #{from_node}, To Node = #{to_node}, Transit Time = #{time_difference}"
        Arc.create(:arc_type => "Dwell", :from_node_id => from_node, :to_node_id => to_node, :transit_time => time_difference)
        from_node = to_node
        from_time = to_time
      else
        from_node = t.id
        previous_station_num = current_station_num
        from_time = t.event_time
      end
    end
  end

  def create_train_arcs
    current_train = 0
    current_node = nil
    previous_station_num = 0
    from_node = 0
    to_node = 0 
    from_time = 0
    to_time = 0
    nodes_with_train_routes = NodeDetail.joins("INNER JOIN train_routes " +
      "ON node_details.station_num = train_routes.station_num " +
      "AND node_details.station_name = train_routes.station_name AND " +
      "( (train_routes.arrive_time_hhhmm = -1 AND train_routes.depart_time_hhhmm = original_event_time) " +
      "OR (train_routes.depart_time_hhhmm = -1 AND train_routes.arrive_time_hhhmm = original_event_time))")
      .select("node_details.station_num, node_details.station_name, node_details.event_time, node_details.id, " + 
        "train_routes.train_number as train_number, train_routes.route_point_seq")
      .order("train_routes.train_number, node_details.station_name, node_details.event_time")
      .all
    logger.debug "Nodes with train data has #{nodes_with_train_routes.size} rows"  
    nodes_with_train_routes.each do |t|
      unless t.train_number.nil?
        logger.debug "Curent Node is #{t.train_number}" unless t.train_number.nil?
        if current_train == t.train_number 
          to_time = t.event_time
          time_difference = to_time - from_time unless from_time.nil?
          to_node = t.id
          Arc.create(
            :arc_type => "Train", 
            :from_node_id => current_node, 
            :to_node_id => to_node, 
            :transit_time => time_difference,
            :train_number => current_train
          )
        else
          current_train = t.train_number 
          from_time = t.event_time
        end
        current_node = t.id
        from_time = t.event_time
      end
    end
  end

  def calculate_path start_station_num, end_station_num, reach_by_hhhmm
    @trip_plan = []
    arc_paths = @acyclic_sp.get_paths start_station_num, end_station_num, reach_by_hhhmm
    arc_paths.each do |x|
      trip_planner = TripPlanner.new
      trip_planner.train_id = x.train_id
      trip_planner.from_station_num = x.from_station_num
      trip_planner.from_station_name = x.from_station_name
      trip_planner.to_station_num = x.to_station_num
      trip_planner.to_station_name = x.to_station_name
      trip_planner.depart_time_dd = x.from_node_event_time_dd
      trip_planner.depart_time = x.from_node_event_time
      trip_planner.arrive_time_dd = x.to_node_event_time_dd
      trip_planner.arrive_time = x.to_node_event_time
      trip_planner.transit_time = x.transit_time
      trip_planner.dwell_time_min = x.to_node_event_time_total_min - x.from_node_event_time_total_min
      trip_planner.arc_type = x.arc_type
      previous_arc = x
      @trip_plan << trip_planner
    end
  end

  def show_itinerary
    begin
      start_station_num = params[:start_station][:station_num]
      end_station_num = params[:end_station][:station_num]
      reach_by_hhhmm = params[:reach_by]
    
      #logger.debug params[:start_station][:station_num] unless params[:start_station].nil?
    
      #create_nodes if Node.all.empty?
    
      #create_arcs if Arc.all.empty?
    
      calculate_path start_station_num, end_station_num, reach_by_hhhmm

      respond_to do |format|
        format.html # show_itinerary.html.erb
        #format.json { render json: @node }
      end
    #@node = Node.find(params[:id])
    
      #logger.debug params.inspect
      #start_station = params[:start_station]
      #end_station = params[:end_station]
      #reach_by = params[:reach_by]
      #ToDo: Protect against SQL injection
      #@itinerary = Itinerary.new start_station, end_station, reach_by
      #@itinerary.compute_trip
      
      #respond_to do |format|
      #  format.html # show.html.erb
      #  format.json { render json: @itinerary }
      #end
    rescue
      #ToDo: Set error message    
    ensure
      #ToDo: Set default itinerary
    end
  end
end
