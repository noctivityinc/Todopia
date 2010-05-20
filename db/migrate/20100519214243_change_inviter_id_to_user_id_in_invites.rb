class ChangeInviterIdToUserIdInInvites < ActiveRecord::Migration
  def self.up
    rename_column :invites, :inviter_id, :user_id
  end

  def self.down
    rename_column :invites, :user_id, :inviter_id
  end
end