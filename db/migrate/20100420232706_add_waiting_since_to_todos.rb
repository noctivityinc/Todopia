class AddWaitingSinceToTodos < ActiveRecord::Migration
  def self.up
    add_column :todos, :waiting_since, :timestamp
  end

  def self.down
    remove_column :todos, :waiting_since
  end
end
