class TrainRoute < ActiveRecord::Base
  attr_accessible :arrive_time_hhhmm, :depart_time_hhhmm, :route_point_seq, :station_name, :station_num, :train_id
end
