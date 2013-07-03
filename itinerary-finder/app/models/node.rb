class Node < ActiveRecord::Base
  #Attributes
  attr_accessible :event_time, :station_num
  
  #Relationships
  has_many :arc
end
