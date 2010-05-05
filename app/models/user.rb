# == Schema Information
# Schema version: 20100505003817
#
# Table name: users
#
#  id                                :integer         not null, primary key
#  login                             :string(255)     not null
#  email                             :string(255)     not null
#  crypted_password                  :string(255)     not null
#  password_salt                     :string(255)     not null
#  persistence_token                 :string(255)     not null
#  single_access_token               :string(255)     not null
#  perishable_token                  :string(255)     not null
#  login_count                       :integer         default(0), not null
#  failed_login_count                :integer         default(0), not null
#  last_request_at                   :datetime
#  current_login_at                  :datetime
#  last_login_at                     :datetime
#  current_login_ip                  :string(255)
#  last_login_ip                     :string(255)
#  created_at                        :datetime
#  updated_at                        :datetime
#  invite_id                         :integer
#  email_daily_summary               :boolean         default(TRUE)
#  daily_summary_sent_at             :datetime
#  email_summary_only_when_todos_due :boolean
#

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = "login"
    disable_perishable_token_maintenance(true)
  end
  has_friendly_id :login

  has_many :tag_groups
  has_many :todos, :dependent => :destroy do
    def unfiled; first.user.tag_groups.empty? ? not_complete : not_complete.tagged_with(first.user.tag_groups.map {|x| x.tag}.join(','), :exclude => true); end
    def filed; first.user.tag_groups.empty? ? nil : not_complete.tagged_with(first.user.tag_groups.map {|x| x.tag}.join(','), :any => true); end
  end

  named_scope :wanting_daily_emails, :conditions => ['(email_daily_summary = ? OR email_summary_only_when_todos_due = ?) AND (daily_summary_sent_at < ? OR daily_summary_sent_at IS ? )', true, true, 1.day.ago.to_datetime, nil]

  before_create :reset_perishable_token

  validate :not_reserved_word
  validates_presence_of :password, :on => :create 
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Postoffice.deliver_password_reset_instructions(self)
  end

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
