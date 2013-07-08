class Arc < ActiveRecord::Base
  #Attributes
  attr_accessible :arc_type, :from_node_id, :to_node_id, :train_id, :transit_time

  #Relationships
  belongs_to :node, :train
  
  #Validations
  validates_associated :node
  validates_inclusion_of :arc_type, :in => ["Dwell", "Train", "dwell", "train"]
  validates_numericality_of :transit_time
  validates_presence_of :event_time, :station_num
  
  
end
