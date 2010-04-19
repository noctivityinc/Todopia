class ChangeCompletedByToCompletedByIdInTodo < ActiveRecord::Migration
  def self.up
    rename_column :todos, :completed_by, :completed_by_id
  end

  def self.down
    rename_column :todos, :completed_by_id, :completed_by
  end
end