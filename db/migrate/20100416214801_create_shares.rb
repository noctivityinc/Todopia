class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
      t.integer :user_id
      t.string :tag
      t.integer :sharee_id
      t.boolean :can_complete
      t.integer :invite_id

      t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end
end
