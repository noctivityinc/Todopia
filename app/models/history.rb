# == Schema Information
# Schema version: 20100414145449
#
# Table name: histories
#
#  id         :integer         not null, primary key
#  todo_id    :integer
#  user_id    :integer
#  event      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :todo
  
  default_scope :order => 'created_at ASC'
  
  validates_presence_of :event
end
