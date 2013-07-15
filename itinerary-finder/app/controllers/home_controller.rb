require "MyNode"
require "AcyclicSP"

class HomeController < ApplicationController

  attr_accessor :node_list, :acyclic_sp, :itinerary_path, :event_times

  def index
  end

  def create_nodes
    # First empty all nodes
    @node_list = {}
    node_id = 1
    TrainRoute.all(:include => :train).each do |tr|
      logger.debug "Node list size is #{tr.train.train_number}" unless tr.train.nil? || tr.train.train_number.nil?
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
=begin
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
=end

  def create_outbound_arcs
    if @event_times.nil?
      arcs_with_nodes = Arc.joins("INNER JOIN node_details ON from_node_id = node_details.id ")
        .select("arcs.arc_type, arcs.from_node_id, arcs.to_node_id, arcs.transit_time, " +
          "arcs.train_number, node_details.station_num, node_details.station_name, " +
          "node_details.event_time, node_details.original_event_time")
        .order("arcs.from_node_id")
                
      # Group all arcs by from_node
      @event_times = {}
      #arcs_with_nodes.order("from_node_id").group(:from_node_id).each do |x|
      arcs_with_nodes.order("from_node_id").each do |x|
        #logger.debug "Arcs is #{x.from_node_id}"
        @event_times[x.from_node_id] = [nil,nil] unless @event_times.has_key? x.from_node_id
        unless x.station_num.nil? || x.station_name.nil?
          # Each subarray has [station_num, station_name, to_node_id, transit time, train number, original event time, arc type]
          new_subarray = [x.event_time, [x.station_num, x.station_name, x.to_node_id, x.transit_time, x.train_number, x.original_event_time, x.arc_type]] 
          @event_times[x.from_node_id] << new_subarray unless @event_times[x.from_node_id].include? new_subarray
        end
      end
      # Now sort the event times
      @event_times.each do |x,y| 
        y[2..-1].sort_by { |u| u[0] }
      end
      logger.debug "Event times are #{@event_times.inspect}"
    end
    #sort by event time and then station number
  end

  def calculate_path start_station_num, end_station_num, reach_by_hhhmm
    #find_node_by_station 70550
    candidate_starting_node = NodeDetail.order(:event_time).all(
      :conditions => ["station_num = ? AND event_time >= ?", start_station_num, reach_by_hhhmm]).first
    logger.debug "Candidate starting node #{candidate_starting_node.inspect}"

    si_found = false
    logger.debug "Event times BEFORE #{@event_times[candidate_starting_node.id].inspect}" 
    @event_times.each do |x,y|
      if x == candidate_starting_node.id 
        si_found = true
        # set total cost to 0
        #logger.debug "BEFORE:Set total cost of node #{x} to 0. Rest is #{y.inspect}"
        y[1] = 0
        #logger.debug "AFTER:Set total cost of node #{x} to 0. Rest is #{y.inspect}"
        #y.each[2..-2] do |p|
        #if p[0] == candidate_starting_node.event_time
        #  
        #  p[1][3] = 0     
        #end
        next
      end
      if si_found
        #set total cost to MAX
        #logger.debug "BEFORE:Set total cost of node #{x} to Max integer. Rest is #{y.inspect}"
        y[1] = Float::INFINITY
        #logger.debug "AFTER:Set total cost of node #{x} to Max integer. Rest is #{y.inspect}"
        #y[1..-1].each do |p| 
          # set total cost to MAX
          #p[1][3] = Float::INFINITY
        #end
      end
    end
    logger.debug "Event times AFTER #{@event_times[candidate_starting_node.id].inspect}"  
    
    finish_node_id = 0
    si_found = false
    destination_found = false
    @event_times.each do |x,y|
      si_found = (x == candidate_starting_node.id) 
      if si_found
        y[2..-1].each do |p| 
          unless  y[0].nil?
            if p[1][0] == end_station_num
              finish_node_id = x
              destination_found = true
              break
            end
          end
          continue if p[1][3] == Float::INFINITY
          # Find to_node of outbound arc
          if @event_times.has_key? p[1][2]
            to_node_of_outbound_arc = p[1][2]
            total_cost_of_to_node = @event_times[to_node_of_outbound_arc][1]
            total_cost_current_node = y[1]
            transit_time_of_outbound_arc = p[1][3]
            if (total_cost_current_node + transit_time_of_outbound_arc < total_cost_of_to_node)
              @event_times[to_node_of_outbound_arc][0] = x
              @event_times[to_node_of_outbound_arc][1]= total_cost_current_node + transit_time_of_outbound_arc
            end
          end
        end
      end
    end
    
    unless finish_node_id == 0
      if destination_found
        @tinerary_path = [] 
        current_predecessor_id = @event_times[finish_node_id][0]
        until current_predecessor_id.nil?
          # get predecessor's outbound arcs'
          predecessor_node = @event_times[current_predecessor_id]
          predecessor_node[2..-1].each do |p|
            pred_arc_to_node_id = p[1][2]
            pred_arc_type = p[1][6]
            if pred_arc_to_node_id == finish_node_id
              @tinerary_path << p
            end
            if pred_arc_type == "Dwell"
              @tinerary_path << p
            end
          end
          finish_node_id = current_predecessor_id
          current_predecessor_id = @event_times[finish_node_id][0]
        end
      end
      @tinerary_path = @tinerary_path.reverse unless @tinerary_path.empty?
      logger.debug "Final iterianry is #{@tinerary_path.inspect}"
    end
#candidate_end_nodes = NodeDetail.all(
    #  :conditions => ["station_num = ? AND event_time >= ?", end_station_num, reach_by_hhhmm])
    #logger.debug "Find nodey by station #{candidate_end_nodes.inspect}"

=begin    
      event_times_for_station = @event_times[end_station_num] 
      event_times_for_station.each do |x|
        if x.event_time <= reach_by_hhhmm
          ending_node = x
          break
        end
      end
      
      unless starting_node.nil? && ending_node.nil?
        destination_found = false
        @route_path << {:node_id => {:total_cost => 0, :from_node => nil, :to_node => starting_node}}
        @event_times.each do |x,y|
          if x == ending_node.from_node_id 
            destination_found = true
            break
          end
        end
        if destination_found
          
        end
      end
    end
=end
  end
  
  def show_itinerary
    begin
      start_station_num = params[:start_station][:station_num]
      end_station_num = params[:end_station][:station_num]
      reach_by_hhhmm = params[:reach_by]
    
      #logger.debug params[:start_station][:station_num] unless params[:start_station].nil?
    
      create_nodes if Node.all.empty? && NodeDetail.all.empty?
      create_dwell_arcs if Arc.find_by_arc_type("Dwell").nil?
      create_train_arcs if Arc.find_by_arc_type("Train").nil?
      create_outbound_arcs
      #logger.debug "Total nodes with arcs are #{@event_times.inspect}"

      #@itinerary_path = AcyclicSP.calculate_path start_station_num, end_station_num, reach_by_hhhmm
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
