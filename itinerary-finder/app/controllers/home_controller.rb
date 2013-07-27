require "MyNode"
require "OutboundArc"

class HomeController < ApplicationController

  attr_accessor :itinerary_path, :event_times

  def index
  end

  def calculate_path start_station_num, end_station_num, depart_by_hhhmm
    @itinerary_path = []
    candidate_starting_node = NodeDetail.order(:event_time).all(
    :conditions => ["station_num = ? AND event_time >= ?", start_station_num, depart_by_hhhmm]).first
    logger.debug "Candidate starting node #{candidate_starting_node.inspect}"

    si_found = false
    @event_times.each do |x,y|
      if x == candidate_starting_node.id
        si_found = true
        y.total_cost = 0
        next
      end
      y.total_cost = Float::INFINITY if si_found
    end

    finish_node_id = 0
    si_found = false
    destination_found = false
    #event_times_after_candidate = @event_times.select do |x,y|
    #  x >= candidate_starting_node.id
    #end
    #logger.debug "Event times AFTER 1/1 #{@event_times.keys.inspect}"
    @event_times.sort.each do |x,y|
      if x == candidate_starting_node.id
        si_found = true
      end
      if si_found
        logger.debug "CALC: Found item Node #{x}, BEFORE #{y.station_num}, predecessor #{y.predecessor} while end station is #{end_station_num}"
        if !y.predecessor.nil? && y.station_num.to_i == end_station_num.to_i
          finish_node_id = x
          destination_found = true
          logger.debug "CALC: Found item AFTER 2/2 #{y.inspect} while end station is #{end_station_num}"
          break
        end
        if y.total_cost != Float::INFINITY
          logger.debug "CALC: Found item POST-AFTER 1/2 #{y.outbound_arcs.inspect}"
          y.outbound_arcs.each do |k|
            #logger.debug "CALC: Found item POST-AFTER 2/2 #{k.inspect} and #{total_cost_of_to_node}"
            arc_destination_node_id = k.to_node
            total_cost_of_to_node = @event_times[arc_destination_node_id].total_cost unless @event_times[arc_destination_node_id].total_cost.nil?
            unless total_cost_of_to_node.nil?
              logger.debug "CALC: Found item POST-AFTER 2/2bb #{k.inspect} and #{total_cost_of_to_node}" unless total_cost_of_to_node.nil?
              if y.total_cost + k.transit_time < total_cost_of_to_node
                @event_times[arc_destination_node_id].predecessor = x
                @event_times[arc_destination_node_id].total_cost = y.total_cost + k.transit_time
                logger.debug "CALC: Updated predecessor and cost for #{@event_times[arc_destination_node_id].inspect} "
              end
            end
          end # finish processing all outbound arcs
        end # ignoring all unreachable nodes

      end
    end

    unless finish_node_id == 0
      if destination_found
        current_predecessor_id = @event_times[finish_node_id].predecessor
        until current_predecessor_id.nil?
          @event_times[current_predecessor_id].outbound_arcs.each do |p|
            #@itinerary_path << p if p.arc_type == "Dwell"
            @itinerary_path << p if p.to_node.to_i == finish_node_id.to_i
          end
          finish_node_id = current_predecessor_id
          current_predecessor_id = @event_times[finish_node_id].predecessor
        end
      end
      @itinerary_path = @itinerary_path.reverse unless @itinerary_path.empty?
      if @itinerary_path.last.arc_type == "Dwell"
        @itinerary_path.pop
      end
    end
  end

  def create_outbound_arcs
    if @event_times.nil? || @event_times.empty?
      arcs_with_nodes = Arc.joins("INNER JOIN node_details N1 ON from_node_id = N1.id INNER JOIN node_details N2 ON to_node_id = N2.id ")
      .select("arcs.arc_type, arcs.from_node_id, arcs.to_node_id, arcs.transit_time, " +
      "arcs.train_number, N1.station_num as from_station_num, N1.station_name as from_station_name, " +
      "N1.event_time, N1.original_event_time, N2.station_name as to_station_name, N2.station_num as to_station_num")
      .order("arcs.from_node_id").group("arcs.from_node_id, arcs.arc_type")

      @event_times = {}
      arc_id = 1
      arcs_with_nodes.each do |x|
        unless x.from_node_id.nil?
          if @event_times.has_key? x.from_node_id
            current_node = @event_times[x.from_node_id]
          else
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
          end
          current_outbound_arc = OutboundArc.new
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
          current_node.outbound_arcs << current_outbound_arc
          arc_id = arc_id + 1
          @event_times[x.from_node_id] = current_node

          # Do the same for to node as well
          unless @event_times.has_key? x.to_node_id
            current_node = MyNode.new
            current_node.node_id = x.to_node_id
            current_node.event_time = x.event_time
            current_node.station_num = x.to_station_num
            current_node.station_name = x.to_station_name
            current_node.original_event_time = x.original_event_time
            current_node.predecessor = nil
            current_node.total_cost = 0
            current_node.start_index = nil
            current_node.sequence_num = nil
            current_node.outbound_arcs = []
          else
            current_node = @event_times[x.to_node_id]
            current_node.event_time = x.event_time
            current_node.station_num = x.to_station_num
            current_node.station_name = x.to_station_name
            current_node.original_event_time = x.original_event_time
          end
          @event_times[x.to_node_id] = current_node
        end
      end
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
    rescue
      #ToDo: Set error message
    ensure
      #ToDo: Set default itinerary
    end
  end
end
