class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.integer :station_num
      t.integer :event_time

      t.timestamps
    end
  end
end
