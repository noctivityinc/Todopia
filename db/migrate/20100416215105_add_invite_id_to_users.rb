class AddInviteIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invite_id, :integer
  end

  def self.down
    remove_column :users, :invite_id
  end
end
