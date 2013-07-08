class Node < ActiveRecord::Base
  #Attributes
  attr_accessible :event_time, :station_num
  
  #Relationships
  has_many :arcs, :dependent => :destroy
  
  #Validations
  validates_numericality_of :event_time, :station_num
  validates_presence_of :event_time, :station_num

end
