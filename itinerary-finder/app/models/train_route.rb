class TrainRoute < ActiveRecord::Base
  # Attributes
  attr_accessible :arrive_time_hhhmm, :depart_time_hhhmm, :route_point_seq, :station_name, :station_num, :train_id
  
  # Relationships
  belongs_to :train
end
