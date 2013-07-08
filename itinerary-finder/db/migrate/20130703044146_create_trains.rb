class CreateTrains < ActiveRecord::Migration  
  def change
    create_table :trains do |t|
      #t.integer :train_number
      t.integer :loop_id
      t.string  :train_category,  :default => "Short Distance", :null => false
      t.boolean :operates_day_1,  :default => false, :null => false
      t.boolean :operates_day_2,  :default => false, :null => false
      t.boolean :operates_day_3,  :default => false, :null => false
      t.boolean :operates_day_4,  :default => false, :null => false
      t.boolean :operates_day_5,  :default => false, :null => false
      t.boolean :operates_day_6,  :default => false, :null => false
      t.boolean :operates_day_7,  :default => false, :null => false
      t.boolean :operates_day_8,  :default => false, :null => false
      t.boolean :operates_day_9,  :default => false, :null => false
      t.boolean :operates_day_10, :default => false, :null => false
      t.boolean :operates_day_11, :default => false, :null => false
      t.boolean :operates_day_12, :default => false, :null => false
      t.boolean :operates_day_13, :default => false, :null => false
      t.boolean :operates_day_14, :default => false, :null => false

      t.timestamps
    end
  end
end
