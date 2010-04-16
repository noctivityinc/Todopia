# == Schema Information
# Schema version: 20100414145449
#
# Table name: notes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  todo_id    :integer
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :todo
  
  default_scope :order => 'created_at DESC'
  
  validates_presence_of :body
end
