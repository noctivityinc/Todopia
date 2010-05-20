class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares, :force => true do |t|
      t.integer :user_id
      t.integer :todo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end
end
