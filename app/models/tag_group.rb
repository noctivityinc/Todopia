# == Schema Information
# Schema version: 20100417164049
#
# Table name: tag_groups
#
#  id         :integer         not null, primary key
#  tag        :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class TagGroup < ActiveRecord::Base
  default_scope :order => 'tag ASC'

  belongs_to :user
  
  named_scope :ordered, :order => 'tag ASC'
  
  
  validates_presence_of :tag, :user
  validates_uniqueness_of :tag, :scope => :user_id
end
