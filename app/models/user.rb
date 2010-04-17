# == Schema Information
# Schema version: 20100416215105
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  login               :string(255)     not null
#  email               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer         default(0), not null
#  failed_login_count  :integer         default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  invite_id           :integer
#

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = "login"
  end
  # has_friendly_id :login

  has_many :todos, :dependent => :destroy

  validate :not_reserved_word

  private

  def not_reserved_word
    if controllers_list.include? self.login 
      self.errors.add('login','is not available.')
      false
    else
      true
    end
  end

  def controllers_list
    @controller_actions = ActionController::Routing::Routes.routes.inject({}) do |controller_actions, route|
      rrc = route.requirements[:controller]
      rrc = rrc.split('/',2)[1] if rrc =~ /\//
      (controller_actions[rrc] ||= []) << route.requirements[:action]
      controller_actions
    end
    @controller_actions.flatten.flatten.uniq
  end
end
