# == Schema Information
# Schema version: 20100519220057
#
# Table name: invite_todos
#
#  id         :integer         not null, primary key
#  invite_id  :integer
#  todo_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class InviteTodo < ActiveRecord::Base
  belongs_to :invite
  belongs_to :todo
  
  validates_presence_of :todo, :invite
  validates_uniqueness_of :todo_id, :scope => :invite_id 
end
