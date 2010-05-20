class CreateInviteTodos < ActiveRecord::Migration
  def self.up
    create_table :invite_todos do |t|
      t.integer :invite_id
      t.integer :todo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :invite_todos
  end
end
