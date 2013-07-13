def populate_trains
  puts "Populating Train table"
  Train.delete_all
  File.open("lib/assets/TRAIN.txt", "r").each do |f|
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

def populate_train_routes
  puts "Now populating Train Routes"
  TrainRoute.delete_all
  File.open("lib/assets/TRAIN_ROUTE.txt", "r").each do |f|
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

populate_trains
populate_train_routes
