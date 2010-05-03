class AddReminderSentAtToTodo < ActiveRecord::Migration
  def self.up
    add_column :todos, :reminder_sent_at, :timestamp
  end

  def self.down
    remove_column :todos, :reminder_sent_at
  end
end
