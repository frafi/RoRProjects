class AcyclicSP
  #Attributes
  attr_accessor :event_times, :route_path

  def initialize
  end

  def self.create_outbound_arcs
    if @@event_times.nil?
      arcs_with_nodes = Arc.joins("INNER JOIN node_details ON from_node_id = node_details.id ")
        .select("arcs.arc_type, arcs.from_node_id, arcs.to_node_id, arcs.transit_time, arcs.train_number, " +
          "node_details.station_num, node_details.event_time, node_details.original_event_time")
        .order("node_details.event_time, node_details.station_num")
      
      # Group all arcs by from_node
      @@event_times = {}
      arcs_with_nodes.group(:from_node_id).each do |x|
        @@event_times[x.from_node_id] = Array.new unless @@event_times.has_key? x.from_node_id
        new_node = MyNode.new x.from_node_id, x.event_time, x.station_num, x.station_name, x.original_event_time, nil, nil
        @@event_times[x.from_node_id] << new_node
      end
    end
    #sort by event time and then station number
  end

  def self.calculate_path start_station_num, end_station_num, reach_by_hhhmm
=begin     
    if @@event_times.has_key? start_station_num
      event_times_for_station = @event_times[start_station_num] 
      event_times_for_station.each do |x|
        if x.event_time <= reach_by_hhhmm
          starting_node = x
          break
        end
      end
      
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
end