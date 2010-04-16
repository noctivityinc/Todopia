class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.integer :todo_id
      t.integer :user_id
      t.string :event
      t.timestamps
    end
  end
  
  def self.down
    drop_table :histories
  end
end
