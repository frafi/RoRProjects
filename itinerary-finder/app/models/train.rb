class Train < ActiveRecord::Base
  #Attributes
  attr_accessible :loop_id, :operates_day_1, :operates_day_10, :operates_day_11, :operates_day_12, :operates_day_13, :operates_day_14, :operates_day_2, :operates_day_3, :operates_day_4, :operates_day_5, :operates_day_6, :operates_day_7, :operates_day_8, :operates_day_9, :train_category

  #Relationships
  has_many :train_routes, :dependent => :destroy
end
