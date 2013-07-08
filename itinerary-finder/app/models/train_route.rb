class TrainRoute < ActiveRecord::Base
  #Attributes
  attr_accessible :arrive_time_hhhmm, :depart_time_hhhmm, :route_point_seq, :station_name, :station_num, :train_id
  
  #Relationships
  belongs_to :train
  
  #Validations
  validates_associated :train
  validates_numericality_of :arrive_time_hhhmm, :depart_time_hhhmm, :station_num, :route_point_seq
  validates_presence_of :arrive_time_hhhmm, :depart_time_hhhmm, :route_point_seq, :station_name, :station_num
  
end
    