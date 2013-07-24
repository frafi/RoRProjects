require "MyNode"
require "OutboundArc"

class HomeController < ApplicationController

  attr_accessor :itinerary_path, :event_times

  def index
  end

  def calculate_path start_station_num, end_station_num, reach_by_hhhmm
    #find_node_by_station 70550
    @tinerary_path = [] 
    candidate_starting_node = NodeDetail.order(:event_time).all(
      :conditions => ["station_num = ? AND event_time >= ?", start_station_num, reach_by_hhhmm]).first
    #logger.debug "Candidate starting node #{candidate_starting_node.inspect}"

    si_found = false
    #logger.debug "Event times BEFORE #{@event_times[candidate_starting_node.id].inspect}" 
    @event_times.each do |x,y|
      if x == candidate_starting_node.id 
        si_found = true
        # set total cost to 0
        #logger.debug "BEFORE:Set total cost of node #{x} to 0. Rest is #{y.inspect}"
        y.total_cost = 0
        #logger.debug "AFTER:Set total cost of node #{x} to 0. Rest is #{y.inspect}"
        next
      end
      if si_found
        #set total cost to MAX
        #logger.debug "BEFORE:Set total cost of node #{x} to Max integer. Rest is #{y.inspect}"
        y.total_cost = Float::INFINITY
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
        unless y.predecessor.nil? 
          if y.station_num == end_station_num 
            finish_node_id = x
            destination_found = true
            break
          end
        end
        if y.total_cost == Float::INFINITY
          continue
        end
        y.outbound_arcs.each do |j,k|
          total_cost_of_to_node = @event_times[k.to_node].total_cost
          if y.total_cost + k.transit_time < total_cost_of_to_node
             @event_times[k.to_node].predecessor = x
             @event_times[k.to_node].total_cost = y.total_cost + k.transit_time 
          end
        end
      end
    end
    if destination_found 
      logger.debug "Found destination" 
    end
      
    unless finish_node_id == 0
      if destination_found
        current_predecessor_id = @event_times[finish_node_id].predecessor
        until current_predecessor_id.nil?
          # get predecessor's outbound arcs'
          predecessor_node = @event_times[current_predecessor_id]
          predecessor_node.outbound_arcs.each do |p,k|
            if k.to_node == finish_node_id
               @tinerary_path << k
            end
            if k.arc_type == "Dwell"
               @tinerary_path << k
            end            
          end
          finish_node_id = current_predecessor_id
          current_predecessor_id = @event_times[finish_node_id].predecessor
        end
      end
      @tinerary_path = @tinerary_path.reverse unless @tinerary_path.empty?
      logger.debug "Final iterianry is #{@tinerary_path.inspect}"
    end

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
    #logger.debug "Populating train arcs"
    if @event_times.nil?
      arcs_with_nodes = Arc.joins("LEFT OUTER JOIN node_details ON from_node_id = node_details.id ")
        .select("arcs.arc_type, arcs.from_node_id, arcs.to_node_id, arcs.transit_time, " +
          "arcs.train_number, node_details.station_num, node_details.station_name, " +
          "node_details.event_time, node_details.original_event_time")
        .order("arcs.from_node_id")
              
      logger.debug "Got arcs is #{arcs_with_nodes.count}"
      # Group all arcs by from_node
      @event_times = {}
      #arcs_with_nodes.order("from_node_id").group(:from_node_id).each do |x|
      #urrent_node = nil
      arc_id = 1
      arcs_with_nodes.order("from_node_id").each do |x|
        #logger.debug "Arcs is #{x.from_node_id}"
        unless x.from_node_id.nil?
          if @event_times.has_key? x.from_node_id
            # Create new outbound arc object and add it to outbound arcs list of existing value
            current_node = @event_times[x.from_node_id]
          else
            #logger.debug "Creating new node for #{x.from_node_id}"
            current_node = MyNode.new
            current_node.node_id = x.from_node_id
            current_node.event_time = x.event_time
            current_node.station_num = x.station_num
            current_node.station_name = x.station_name
            current_node.original_event_time = x.original_event_time
            current_node.predecessor = nil
            current_node.total_cost = nil
            current_node.start_index = nil
            current_node.sequence_num = nil
            current_node.outbound_arcs = {}
            #logger.debug "Current node is #{current_node.inspect}"
          end         
          current_outbound_arc = OutboundArc.new
          #logger.debug "Current arc is #{current_outbound_arc.inspect}"
          current_outbound_arc.arc_id = arc_id
          current_outbound_arc.cost = nil
          current_outbound_arc.transit_time = x.transit_time
          current_outbound_arc.time_difference = nil
          current_outbound_arc.from_node = x.from_node_id
          current_outbound_arc.to_node = x.to_node_id
          current_outbound_arc.arc_type = x.arc_type
          current_outbound_arc.train_id = x.train_number
          #logger.debug "Current arc is #{current_outbound_arc.inspect}"
          current_node.outbound_arcs[x.event_time] = current_outbound_arc
          arc_id = arc_id + 1
          @event_times[x.from_node_id] = current_node
        end
      end
        # Now sort the event times
      #@event_times.each do |x,y| 
      #  y[2..-1].sort_by { |u| u[0] }
      #end
      #logger.debug "All Event times are #{@event_times.inspect}"
    end
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
