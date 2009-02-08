class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.datetime :created_at
      t.datetime :updated_at
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :nodes
  end
end
