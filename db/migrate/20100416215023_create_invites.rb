class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer :inviter_id
      t.string :email
      t.string :name
      t.string :token
      t.timestamp :accepted_at
      t.timestamps
    end
  end
  
  def self.down
    drop_table :invites
  end
end
