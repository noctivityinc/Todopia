class AddEmailDailySummaryAndDailySummarySentAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_daily_summary, :boolean, :default => true 
    add_column :users, :daily_summary_sent_at, :timestamp
    add_column :users, :email_summary_only_when_todos_due, :boolean, :default => false 
    
    User.all.each do |user|
      user.update_attribute(:email_daily_summary, true)
    end
  end

  def self.down
    remove_column :users, :email_summary_only_when_todos_due
    remove_column :users, :daily_summary_sent_at
    remove_column :users, :email_daily_summary
  end
end
