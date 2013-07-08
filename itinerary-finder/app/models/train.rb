class Train < ActiveRecord::Base
  #Attributes
  attr_accessible :loop_id, :operates_day_1, :operates_day_10, :operates_day_11, :operates_day_12, :operates_day_13, :operates_day_14, :operates_day_2, :operates_day_3, :operates_day_4, :operates_day_5, :operates_day_6, :operates_day_7, :operates_day_8, :operates_day_9, :train_category

  #Relationships
  has_many :train_routes, :dependent => :destroy
  has_many :arcs, :dependent => :destroy

  #Validations
  # ToDo: Use case insensitive search here (regular expresions)
  validates_inclusion_of :train_category, :in => ["Long Distance", "Short Distance", "long distance", "short distance"]
  validates_numericality_of :loop_id
  validates_presence_of :train_category, :loop_id
end
