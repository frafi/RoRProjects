class CreateTrainRoutes < ActiveRecord::Migration
  def change
    create_table :train_routes do |t|
      t.integer :train_id
      t.integer :route_point_seq
      t.integer :station_num
      t.string :station_name
      t.integer :arrive_time_hhhmm
      t.integer :depart_time_hhhmm

      t.timestamps
    end
    #add_foreign_key :train_routes, :train_id, :trains
  end
  
  def self.up
    change
  end

  def self.down
    #drop_foreign_key :train_routes, :train_id
    drop_table :train_routes
  end
  
  def self.add_foreign_key(table, column, referenced_table)
    execute %(
      alter table #{table}
      add constraint #{fk_name(table, column)}
      foreign key (#{column})
      references #{referenced_table}(id)
    )
  end

  def self.drop_foreign_key(table, column)
    execute %(
      alter table #{table}
      drop foreign key #{fk_name(table, column)}
    )
  end

  def self.fk_name(table, column)
    "fk_#{table}_#{column}"
  end
end
