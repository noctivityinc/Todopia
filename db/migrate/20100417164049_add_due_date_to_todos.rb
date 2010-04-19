class AddDueDateToTodos < ActiveRecord::Migration
  def self.up
    add_column :todos, :due_date, :date
  end

  def self.down
    remove_column :todos, :due_date
  end
end
