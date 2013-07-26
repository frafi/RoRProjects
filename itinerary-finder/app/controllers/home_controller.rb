require "MyNode"
require "OutboundArc"

class HomeController < ApplicationController

  attr_accessor :itinerary_path, :event_times

  def index
  end

  def calculate_path start_station_num, end_station_num, reach_by_hhhmm
    #find_node_by_station 70550
    @itinerary_path = [] 
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
      #else
        #continue
      end
    end
    #logger.debug "Event times AFTER 0/1 #{@event_times[candidate_starting_node.id].inspect}"  
    
    break_code = false
    finish_node_id = 0
    si_found = false
    destination_found = false
    logger.debug "Event times AFTER 1/1 #{@event_times.inspect}"      
    @event_times.each do |x,y|
      if x == candidate_starting_node.id
        si_found = true
      end
      if si_found
        logger.debug "CALC: Found item BEFORE #{y.station_num}, predecessor #{y.predecessor} while end station is #{end_station_num}"
        if !y.predecessor.nil? && y.station_num.to_i == end_station_num.to_i
            #logger.debug "CALC: Found item AFTER 1/2 #{y.inspect} while end station is #{end_station_num}"
            finish_node_id = x
            destination_found = true
            logger.debug "CALC: Found item AFTER 2/2 #{y.inspect} while end station is #{end_station_num}"
            break
        end
        if y.total_cost != Float::INFINITY
          #continue
        logger.debug "CALC: Found item POST-AFTER 1/2 #{y.outbound_arcs.inspect}"
        y.outbound_arcs.each do |k|
          #logger.debug "CALC: Found item POST-AFTER 2/2 #{k.inspect} and #{total_cost_of_to_node}"
          arc_destination_node_id = k.to_node
          #logger.debug "CALC: Found item POST-AFTER 2/2a" if @event_times.has_key? arc_destination_node_id
          #next_node =  @event_times[arc_destination_node_id] 
          #logger.debug "CALC: Found item POST-AFTER 2/2b #{@event_times[arc_destination_node_id].inspect}"
          total_cost_of_to_node = @event_times[arc_destination_node_id].total_cost unless @event_times[arc_destination_node_id].total_cost.nil? 
          
          unless total_cost_of_to_node.nil?
            #logger.debug "CALC: Found item POST-AFTER 2/2bb #{k.inspect} and #{total_cost_of_to_node}" unless total_cost_of_to_node.nil?
          if y.total_cost + k.transit_time < total_cost_of_to_node
             @event_times[arc_destination_node_id].predecessor = x
             @event_times[arc_destination_node_id].total_cost = y.total_cost + k.transit_time 
             #@event_times[arc_destination_node_id].from_station_name = y.station_name.to_s
             logger.debug "CALC: Updated predecessor and cost for #{@event_times[arc_destination_node_id].inspect} "
          end
          end
          end
        end
        
      #else
        #continue
      end
    end
    if destination_found 
      logger.debug "Destination found #{finish_node_id}" 
    end
      
    unless finish_node_id == 0
      if destination_found
        current_predecessor_id = @event_times[finish_node_id].predecessor
        until current_predecessor_id.nil?
          # get predecessor's outbound arcs'
          predecessor_node = @event_times[current_predecessor_id]
          predecessor_node.outbound_arcs.each do |p|
            if p.to_node.to_i == finish_node_id.to_i
               @itinerary_path << p
            end
            if p.arc_type == "Dwell"
               @itinerary_path << p
            end            
          end
          finish_node_id = current_predecessor_id
          current_predecessor_id = @event_times[finish_node_id].predecessor
        end
      end
      @itinerary_path = @itinerary_path.reverse unless @itinerary_path.empty?
      logger.debug "Final iterianry is #{@itinerary_path.inspect}"
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
    #if @event_times.nil?
      arcs_with_nodes = Arc.joins("INNER JOIN node_details N1 ON from_node_id = N1.id INNER JOIN node_details N2 ON to_node_id = N2.id ")
        .select("arcs.arc_type, arcs.from_node_id, arcs.to_node_id, arcs.transit_time, " +
          "arcs.train_number, N1.station_num as from_station_num, N1.station_name as from_station_name, " +
          "N1.event_time, N1.original_event_time, N2.station_name as to_station_name, N2.station_num as to_station_num")
        .order("arcs.from_node_id").group("arcs.from_node_id")
              
      #logger.debug "Got arcs is #{arcs_with_nodes.count}"
      # Group all arcs by from_node
      @event_times = {}
      #arcs_with_nodes.order("from_node_id").group(:from_node_id).each do |x|
      #urrent_node = nil
      arc_id = 1
      dwell_arcs = 0
      train_arcs = 0
      arcs_with_nodes.each do |x|
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
            current_node.station_num = x.from_station_num
            current_node.station_name = x.from_station_name
            current_node.original_event_time = x.original_event_time
            current_node.predecessor = nil
            current_node.total_cost = 0
            current_node.start_index = nil
            current_node.sequence_num = nil
            current_node.outbound_arcs = []
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
          current_outbound_arc.from_station_num = x.from_station_num
          current_outbound_arc.to_station_num = x.to_station_num
          current_outbound_arc.depart_time = x.event_time
          #logger.debug "Current arc is #{current_outbound_arc.inspect}"
          current_node.outbound_arcs << current_outbound_arc
          if x.arc_type.eql? "Dwell"
            dwell_arcs = dwell_arcs + 1
          else
            train_arcs = train_arcs + 1
          end
          arc_id = arc_id + 1
          @event_times[x.from_node_id] = current_node
        end
      end
        # Now sort the event times
      #@event_times.each do |x,y| 
      #  y[2..-1].sort_by { |u| u[0] }
      #end
      logger.debug "All outbound arcs in Event times are #{train_arcs+dwell_arcs} whereas dwell arcs are #{dwell_arcs}"
    #end
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
