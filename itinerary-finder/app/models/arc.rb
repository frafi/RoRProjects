class Arc < ActiveRecord::Base
  #Attributes
  attr_accessible :arc_type, :from_node_id, :to_node_id, :train_number, :transit_time

  #Relationships
  belongs_to :node, :primary_key => "id", :foreign_key => "from_node_id"
  belongs_to :node, :primary_key => "id", :foreign_key => "to_node_id"
  belongs_to :train, :foreign_key => "train_number"
  #belongs_to :train
  
  #Validations
  validates_associated :node
  #validates_inclusion_of :arc_type, :in => ["Dwell", "Train", "dwell", "train"]
  validates_numericality_of :transit_time
  
  
end
