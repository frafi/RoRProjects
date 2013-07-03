class CreateTrains < ActiveRecord::Migration
  def change
    create_table :trains do |t|
      t.integer :loop_id
      t.string :train_category
      t.boolean :operates_day_1
      t.boolean :operates_day_2
      t.boolean :operates_day_3
      t.boolean :operates_day_4
      t.boolean :operates_day_5
      t.boolean :operates_day_6
      t.boolean :operates_day_7
      t.boolean :operates_day_8
      t.boolean :operates_day_9
      t.boolean :operates_day_10
      t.boolean :operates_day_11
      t.boolean :operates_day_12
      t.boolean :operates_day_13
      t.boolean :operates_day_14

      t.timestamps
    end
  end
end
