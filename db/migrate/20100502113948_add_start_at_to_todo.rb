class AddStartAtToTodo < ActiveRecord::Migration
  def self.up
    add_column :todos, :starts_at, :timestamp
  end

  def self.down
    remove_column :todos, :start_at
  end
end
