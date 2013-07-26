require "MyNode"

def populate_trains train_file
  puts "Populating Train table"
  Train.delete_all
  File.open("lib/assets/#{train_file}.txt", "r").each do |f|
    train_number, loop_id, category, day_1, day_2, day_3, day_4, day_5, day_6, day_7, day_8, day_9, day_10, day_11, day_12, day_13, day_14 = f.chomp.split("|")
    Train.create(
      :id => train_number,
      :train_number => train_number,
      :loop_id => loop_id, 
      :train_category => category,
      :operates_day_1 => day_1,   :operates_day_2 => day_2,   :operates_day_3 => day_3,   :operates_day_4 => day_4, 
      :operates_day_5 => day_5,   :operates_day_6 => day_6,   :operates_day_7 => day_7,   :operates_day_8 => day_8, 
      :operates_day_9 => day_9,   :operates_day_10 => day_10, :operates_day_11 => day_11, :operates_day_12 => day_12, 
      :operates_day_13 => day_13, :operates_day_14 => day_14
    )
  end
  puts "Added #{Train.all.count} records"
end

def populate_train_routes train_route_file
  puts "Now populating Train Routes"
  TrainRoute.delete_all
  File.open("lib/assets/#{train_route_file}.txt", "r").each do |f|
    train_number, point_seq, station_num, station_name, arrive_time, depart_time = f.chomp.split("|")
    TrainRoute.create(
      :train_number => train_number, 
      :route_point_seq => point_seq,
      :station_num => station_num,
      :station_name => station_name,
      :arrive_time_hhhmm => arrive_time,
      :depart_time_hhhmm => depart_time
    )
  end
  puts "Added #{TrainRoute.all.count} records"
end

def create_nodes
  puts "Populating nodes and node details"
  Node.delete_all
  NodeDetail.delete_all
  # First empty all nodes
  node_list = {}
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
        new_node = MyNode.new
        new_node.node_id = node_id
        new_node.event_time = computed_minutes
        new_node.station_num = tr.station_num
        new_node.station_name = tr.station_name
        new_node.original_event_time = event_time
        node_list[node_key] = new_node      
        node_id =+ 1
      end
    end
  end
  #puts "Node list size is #{node_list.inspect}"
  node_list.keys.sort.each do |p|
    Node.create(:station_num => node_list[p].station_num, :event_time => node_list[p].event_time)
    NodeDetail.create(
      :station_num => node_list[p].station_num, 
      :station_name => node_list[p].station_name, 
      :event_time => node_list[p].event_time,
      :original_event_time => node_list[p].original_event_time
    )
  end
  puts "Node table size is #{Node.all.size}"
end     

def create_dwell_arcs
  Arc.delete_all
  puts "Populating dwell arcs"
  # Join node list against Train Route
  current_station_num = 0
  previous_station_num = 0
  from_node = 0
  to_node = 0 
  from_time = 0
  to_time = 0
  nodes_with_train_routes = NodeDetail.joins("INNER JOIN train_routes " +
    "ON node_details.station_num = train_routes.station_num AND original_event_time = " +
    "CASE WHEN train_routes.arrive_time_hhhmm = -1 THEN train_routes.depart_time_hhhmm ELSE train_routes.arrive_time_hhhmm END " +
    "AND node_details.station_name = train_routes.station_name " +
    "AND NOT (train_routes.arrive_time_hhhmm <> -1 AND train_routes.depart_time_hhhmm <> -1)").
    select("node_details.station_num, node_details.station_name, node_details.event_time, node_details.id, train_routes.arrive_time_hhhmm as arrival_time, train_routes.depart_time_hhhmm as departure_time")
    .order("node_details.station_num, node_details.station_name, node_details.event_time")
    .group("node_details.station_num, node_details.station_name, node_details.event_time")

=begin    
  nodes_with_train_routes = NodeDetail.joins("INNER JOIN train_routes " +
    "ON node_details.station_num = train_routes.station_num " +
    "AND node_details.station_name = train_routes.station_name").
    where("node_details.original_event_time = CASE WHEN train_routes.arrive_time_hhhmm = -1 THEN train_routes.depart_time_hhhmm ELSE train_routes.arrive_time_hhhmm END " +
     "AND train_routes.arrive_time_hhhmm <> -1 AND train_routes.depart_time_hhhmm <> -1").
    select("node_details.station_num, node_details.station_name, node_details.event_time, node_details.id, train_routes.arrive_time_hhhmm as arrival_time, train_routes.depart_time_hhhmm as departure_time")
    .order("node_details.station_num, node_details.station_name, node_details.event_time").all
=end
    nodes_with_train_routes.each do |t|
      if current_station_num == 0 && previous_station_num == 0 
        from_node = t.id
        #logger.debug "From Node = #{from_node}"
        previous_station_num = t.station_num
        from_time = t.event_time
        next
      end
      current_station_num = t.station_num
      if current_station_num == previous_station_num
        to_node = t.id
        to_time = t.event_time
        time_difference = to_time - from_time unless from_time.nil?
        #logger.debug "From Node = #{from_node}, To Node = #{to_node}, Transit Time = #{time_difference}"
        Arc.create(:arc_type => "Dwell", :from_node_id => from_node, :to_node_id => to_node, :transit_time => time_difference)
        from_node = to_node
        from_time = to_time
      else
        from_node = t.id
        previous_station_num = current_station_num
        from_time = t.event_time
      end
    end    
  total_dwell_arcs = Arc.where(arc_type: "Dwell").size
  puts "Total dwell arcs are #{total_dwell_arcs}"  
end

def create_train_arcs
  puts "Populating train arcs"
  current_train = 0
  current_node = nil
  previous_station_num = 0
  from_node = 0
  to_node = 0 
  from_time = 0
  to_time = 0
  nodes_with_train_routes = NodeDetail.joins("INNER JOIN train_routes " +
    "ON node_details.station_num = train_routes.station_num AND original_event_time = " +
    "CASE WHEN train_routes.arrive_time_hhhmm = -1 THEN train_routes.depart_time_hhhmm ELSE train_routes.arrive_time_hhhmm END " +
    "AND node_details.station_name = train_routes.station_name AND " +
    "train_routes.depart_time_hhhmm <> -1 AND train_routes.depart_time_hhhmm = node_details.original_event_time").
    select("node_details.station_num, node_details.station_name, node_details.event_time, node_details.id, " + 
      "train_routes.train_number as train_number, train_routes.route_point_seq")
    .order("node_details.event_time, train_routes.train_number, train_routes.route_point_seq")
    .group("node_details.station_num, node_details.station_name, node_details.event_time")
    .all
  #logger.debug "Nodes with train data has #{nodes_with_train_routes.size} rows"  
  nodes_with_train_routes.each do |t|
    unless t.train_number.nil?
      #logger.debug "Curent Node is #{t.train_number}" unless t.train_number.nil?
      if current_train == t.train_number 
        to_time = t.event_time
        time_difference = (to_time - from_time).abs unless from_time.nil?
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
  total_train_arcs = Arc.where(arc_type: "Train").size
  puts "Total train arcs are #{total_train_arcs}"  
end
  
populate_trains "TRAIN_small" unless Train.exists?
populate_train_routes "TRAIN_ROUTE_small" unless TrainRoute.exists?
create_nodes unless Node.exists? 
#&& NodeDetail.exists?)
create_dwell_arcs #unless Arc.exists? || Arc.where(arc_type: "Dwell").size.zero?
create_train_arcs #unless Arc.exists? || Arc.where(arc_type: "Train").size.zero?