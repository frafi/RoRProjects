class Arc < ActiveRecord::Base
  attr_accessible :arc_type, :from_node_id, :to_node_id, :train_id, :transit_time
end
