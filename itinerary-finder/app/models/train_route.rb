class TrainRoute < ActiveRecord::Base
  #Attributes
  attr_accessible :arrive_time_hhhmm, :depart_time_hhhmm, :route_point_seq, :station_name, :station_num, :train_number, :train_id
  
  #Relationships
  belongs_to :train, :primary_key => "train_number", :foreign_key => "train_number"
  has_many :node_details
  
  #Validations
  validates_associated :train
  validates_numericality_of :arrive_time_hhhmm, :depart_time_hhhmm, :station_num, :route_point_seq
  validates_presence_of :arrive_time_hhhmm, :depart_time_hhhmm, :route_point_seq, :station_name, :station_num
end
    