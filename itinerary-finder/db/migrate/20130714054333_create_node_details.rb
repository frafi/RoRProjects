class CreateNodeDetails < ActiveRecord::Migration
  def change
    create_table :node_details do |t|
      t.integer :station_num
      t.string  :station_name
      t.integer :event_time
      t.integer :original_event_time

      t.timestamps
    end
  end
end
