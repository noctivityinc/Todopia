class CreateTodos < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|
      t.string :label
      t.integer :position
      t.datetime :completed_at
      t.integer :user_id
      t.integer :completed_by
      t.timestamps
    end
  end
  
  def self.down
    drop_table :todos
  end
end
