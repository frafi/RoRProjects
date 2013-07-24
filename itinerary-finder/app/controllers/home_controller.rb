class HomeController < ApplicationController

  attr_accessor :itinerary_path, :event_times

  def index
  end

  def calculate_path start_station_num, end_station_num, reach_by_hhhmm
    #find_node_by_station 70550
    @tinerary_path = [] 
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
        next
      end
      if si_found
        #set total cost to MAX
        #logger.debug "BEFORE:Set total cost of node #{x} to Max integer. Rest is #{y.inspect}"
        y[1] = Float::INFINITY
        #logger.debug "AFTER:Set total cost of node #{x} to Max integer. Rest is #{y.inspect}"
      end
    end
    #logger.debug "Event times AFTER #{@event_times[candidate_starting_node.id].inspect}"  
    #logger.debug "Event times AFTER #{@event_times.inspect}"  
    
    break_code = false
    finish_node_id = 0
    si_found = false
    destination_found = false
    @event_times.each do |x,y|
      if x == candidate_starting_node.id
        si_found = true
      end
      if si_found
        #logger.debug "CALC: Found item BEFORE #{y.inspect} while end station is #{end_station_num}"
        y[2..-1].each do |p| 
          logger.debug "CALC: This station is #{p[1][0].inspect}, end station is #{end_station_num} and predecessor is #{@event_times[y[0]].inspect}"
          #unless  y[0].nil?
            if p[1][0] == end_station_num
              #logger.debug "CALC: This event time array is #{p[1][0].inspect} and predecessor is #{y[0].inspect}"
              finish_node_id = x
              destination_found = true
              break
            end
          #end
          continue if y[1] == Float::INFINITY
          # Find to_node of outbound arc
          if @event_times.has_key? p[1][2]
            to_node_of_outbound_arc = p[1][2]
            total_cost_of_to_node = @event_times[to_node_of_outbound_arc][1]
            total_cost_current_node = y[1]
            transit_time_of_outbound_arc = p[1][3]
            logger.debug "total_cost_current_node #{total_cost_current_node} transit_time_of_outbound_arc #{transit_time_of_outbound_arc} total_cost_of_to_node #{total_cost_of_to_node}"
            if (total_cost_current_node + transit_time_of_outbound_arc < total_cost_of_to_node)
              @event_times[to_node_of_outbound_arc][0] = x
              @event_times[to_node_of_outbound_arc][1]= total_cost_current_node + transit_time_of_outbound_arc
              logger.debug "predecessor #{@event_times[to_node_of_outbound_arc][0]}, station #{@event_times[to_node_of_outbound_arc][2][1][0].inspect}  and cost #{@event_times[to_node_of_outbound_arc][1]}"
            end
          end
        end
        break if destination_found 
      end
    end
    
    if destination_found 
      logger.debug "Found destination" 
    end
      
    unless finish_node_id == 0
      if destination_found
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
  
  def create_outbound_arcs
    logger.debug "Populating train arcs"
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
      #logger.debug "All Event times are #{@event_times.inspect}"
    end
    #sort by event time and then station number
  end
   
  def show_itinerary
    begin
      start_station_num = params[:start_station][:station_num]
      end_station_num = params[:end_station][:station_num]
      reach_by_hhhmm = params[:reach_by]
    
      create_outbound_arcs
      
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
