# == Schema Information
# Schema version: 20100519214243
#
# Table name: shares
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  todo_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Share < ActiveRecord::Base
  belongs_to :user
  belongs_to :todo

  validates_presence_of :user, :todo
  validates_uniqueness_of :todo_id, :scope => [:user_id], :message => 'has already been shared with this user' 
end
