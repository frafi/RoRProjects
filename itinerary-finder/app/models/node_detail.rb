class NodeDetail < ActiveRecord::Base
  attr_accessible :event_time, :original_event_time, :station_name, :station_num

  #Relationships
  has_many :arcs
  belongs_to :train_route, :foreign_key => "train_number,station_name,station_num"
  
  #Validations
  validates_numericality_of :event_time, :station_num, :original_event_time
  validates_presence_of :event_time, :station_num, :original_event_time, :station_name
end
