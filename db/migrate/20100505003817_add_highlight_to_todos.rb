class AddHighlightToTodos < ActiveRecord::Migration
  def self.up
    add_column :todos, :highlight, :boolean
  end

  def self.down
    remove_column :todos, :highlight
  end
end
