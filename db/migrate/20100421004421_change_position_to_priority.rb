class ChangePositionToPriority < ActiveRecord::Migration
  def self.up
    rename_column :todos, :position, :priority
  end

  def self.down
    rename_column :todos, :priority, :position
  end
end