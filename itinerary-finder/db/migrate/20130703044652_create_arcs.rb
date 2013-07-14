class CreateArcs < ActiveRecord::Migration
  def change
    create_table :arcs do |t|
      t.string :arc_type
      t.integer :from_node_id
      t.integer :to_node_id
      t.integer :transit_time
      t.integer :train_number

      t.timestamps
    end
  end
end
