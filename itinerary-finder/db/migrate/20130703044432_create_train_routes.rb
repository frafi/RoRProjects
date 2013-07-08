class CreateTrainRoutes < ActiveRecord::Migration
  def change
    create_table :train_routes do |t|
      t.integer :train_id
      t.integer :route_point_seq
      t.integer :station_num
      t.string  :station_name
      t.integer :arrive_time_hhhmm
      t.integer :depart_time_hhhmm

      t.timestamps
    end
  end
end
