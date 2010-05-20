# == Schema Information
# Schema version: 20100519214243
#
# Table name: invites
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  email       :string(255)
#  name        :string(255)
#  token       :string(255)
#  accepted_at :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Invite < ActiveRecord::Base
  belongs_to :user
  has_many :invite_todos, :dependent => :destroy 
  has_many :todos, :through => :invite_todos

  validates_presence_of :email, :user

  named_scope :pending, :conditions => ['accepted_at IS ?', nil]

  before_create :generate_token

  private

  def generate_token
    self.token = Authlogic::Random.friendly_token
  end

end
