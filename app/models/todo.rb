# == Schema Information
# Schema version: 20100505003817
#
# Table name: todos
#
#  id               :integer         not null, primary key
#  label            :string(255)
#  priority         :integer
#  completed_at     :datetime
#  user_id          :integer
#  completed_by_id  :integer
#  created_at       :datetime
#  updated_at       :datetime
#  due_date         :date
#  waiting_since    :datetime
#  starts_at        :datetime
#  reminder_sent_at :datetime
#  highlight        :boolean
#

class Todo < ActiveRecord::Base
  attr_accessor :completed, :previous_tag_list, :tag_string, :notice, :error, :warning
  acts_as_taggable_on :tags

  has_many :notes, :dependent => :destroy
  has_many :histories, :dependent => :destroy
  has_many :shares
  has_many :invite_todos
  has_many :invites, :through => :invite_todos
  belongs_to :user
  belongs_to :completed_by, :class_name => "User", :foreign_key => "completed_by_id"

  validates_presence_of :label
  validate :not_labelify_label

  named_scope :not_complete, :conditions => ['completed_at IS ?', nil], :order => 'waiting_since DESC, priority ASC, due_date ASC, created_at DESC'
  named_scope :due, :conditions => ['due_date <= ? AND due_date IS NOT ?', Date.today, nil]
  named_scope :not_due, :conditions => ['due_date > ? OR due_date IS ?', Date.today, nil]
  named_scope :in_process, :conditions => ['waiting_since IS NOT ?', nil]
  named_scope :not_in_process, :conditions => ['waiting_since IS ?', nil]
  named_scope :complete, :conditions => ['completed_at IS NOT ?', nil], :order => 'completed_at DESC'
  named_scope :scheduled, :conditions => ['starts_at IS NOT ?', nil]
  named_scope :active, :conditions => ['starts_at IS ? OR starts_at <= ?', nil, Date.today]
  named_scope :ordered, :order => 'due_date ASC, priority ASC, position ASC'
  named_scope :ordered_by, lambda {|what| {:order => what}}

  before_create :set_priority
  before_save :set_completed_by_id, :tag_string_to_tag_list, :pre_tag_plugins
  before_update :check_completed

  after_save :post_tag_plugins

  RE_EMAIL = /^([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4})$/i
  RE_LOGIN = /^(@(\w+))/i

  def toggle_waiting
    self.waiting_since = (self.waiting_since ? nil : Time.now)
    self.save
  end

  def uncheck(current_user)
    self.completed_by = self.completed_at = nil
    self.save
    notify_others_of_uncheck(current_user) if self.shared?
  end

  def delete_tag(tag)
    self.tags.find_by_name(tag).destroy rescue nil
  end

  def rename_tag(tag_name, new_name)
    if self.tags.find_by_name(tag_name)
      self.tag_list = self.tag_list - [tag_name]
      self.tag_list.push(new_name)
      self.save
    end
  end

  def active
    starts_at.blank? || starts_at < Time.now
  end

  def not_active
    starts_at && starts_at >= Time.now
  end

  def created_by?(user)
    self.user == user
  end

  def shared?
    !self.shares.empty?
  end

  def shared_with?(user)
    self.shares.find_by_user_id(user.id)
  end

  private

  def not_labelify_label
    if self.label.strip == '+ Add new todo'
      errors.add('label','cannot be blank')
      return false
    end
  end

  def set_priority
    self.priority ||= 10
  end

  def set_completed_by_id
    self.completed_by_id = completed_by.id if completed_by
  end

  def new_tag?(tag)
    !previous_tag_list.include?(tag)
  end

  def check_completed
    if self.completed
      self.completed_at = Time.now
      notify_others_of_completion if self.shared?
    end
  end

  def tag_string_to_tag_list
    self.previous_tag_list = self.tag_list
    self.tag_list = filter_plugins.downcase unless self.tag_string.nil?
  end

  def filter_plugins
    return tag_string if tag_string.blank?

    new_list = self.tag_string.split(',').map do |tag|
      tag.strip!
      if %w{!}.include?(tag[0])
        tag[1..-1]
      elsif !(tag =~ /^(due|by)\s(.*)/i)
        tag
      end
    end.compact
    new_list = new_list - ['#!'] # => filter out keywords that cause action which should not be tags
    new_list.join(',')
  end

  def pre_tag_plugins
    return unless self.tag_string

    self.starts_at = self.due_date = self.highlight = nil

    self.tag_string.split(',').each { |tag|
      tag.strip!

      if !tag.scan(/^(start|begin)s?(\s[at|on])?\s(.*)\b/i).empty?
        self.starts_at = Chronic.parse(tag)
      elsif tag =~ /^(due|by)\s(.*)/i
        self.due_date = Chronic.parse(tag.match(/^(due|by)\s(.*)/i)[2])
      elsif Chronic.parse(tag)
        self.due_date = Chronic.parse(tag)
      elsif tag.starts_with? '#'
        tag[1] == '!' ? (self.highlight = true) : (self.priority = tag[1..-1])
      elsif tag =~ RE_EMAIL && new_tag?(tag)
        return false unless share_by_email(tag)
      elsif tag =~ RE_LOGIN && new_tag?(tag) &&  new_tag?(tag)
        return false unless share_by_login(tag)
      end
    }

    self.starts_at = self.due_date if self.starts_at && self.due_date && self.due_date < self.starts_at # => prevents setting a due date before the event starts
  end

  def post_tag_plugins
    self.tag_string.downcase.split(',').each do |tag|
      tag.strip!
      self.user.tag_groups.create(:tag => tag[1..-1]) if tag.starts_with? '!'
    end if self.tag_string

    tag_emails = []
    self.tag_list.each do |tag|
      tag_emails << tag if tag =~ RE_EMAIL
      tag_emails << User.find_by_login(tag.match(RE_LOGIN)[2]).email if tag =~ RE_LOGIN
    end
    process_removed_shares(tag_emails)
  end

  def share_by_email(tag)
    email = tag.match(RE_EMAIL)[1]
    user = User.find_by_email(email)
    if user
      return share(user)
    else
      self.notice = "An invitation has been sent to #{email} to share this todo."
      invite = self.user.invites.find_or_create_by_email(email)
      invite.invite_todos.build(:todo => self)
      Postoffice.deliver_invite_and_share(invite, self)
      return true
    end
  end

  def share_by_login(tag)
    user = User.find_by_login(tag.match(RE_LOGIN)[2])
    if user
      return share(user) if user != self.user
    else
      self.error = "You cannot share this todo with #{tag} as they do not exist in Todopia."
    end

    return false
  end

  def share(sharee)
    if !self.created_by?(sharee) && !self.shared_with?(sharee) # => make sure we dont resend or add share twice if already shared with this individual
      if self.shares.build(:user => sharee)
        Postoffice.deliver_share(sharee, self)
        self.notice = "This todo has been shared with @#{sharee.login}"
        return true
      end
    end
    self.warning = "This todo has already been shared with #{sharee.login}"
    return false
  end

  def process_removed_shares(tag_emails)
    shared_emails = self.shares.map {|share| share.user.email }
    removed_emails = shared_emails - tag_emails
    removed_emails.each {|email| remove_share(email)}

    invited_emails = self.invites.pending.map {|invite| invite.email}
    uninvited_emails = invited_emails - tag_emails
    uninvited_emails.each {|email| uninvite(email)}
  end

  def remove_share(email)
    sharee = User.find_by_email(email)
    share = self.shares.find_by_user_id(sharee.id)

    # send a note to the one that shared and the one removed about the removal
    Postoffice.deliver_removed_share(share.user.email, share)
    Postoffice.deliver_removed_share(self.user.email, share)

    self.warning = "@#{sharee.login} has been removed from the todo"

    share.delete
  end

  def uninvite(email)
    invite = Invite.find_by_email(email)
    self.warning = "#{email} has been uninvited from this todo."
    invite.invite_todos.find_by_todo_id(self.id).delete
  end

  def notify_others_of_completion
    Postoffice.deliver_todo_complete(self, self.user) # => notify the creator
    self.shares.each do |share|
      Postoffice.deliver_todo_complete(self, share.user) # and everyone else
    end
  end
  
  def notify_others_of_uncheck(current_user)
    Postoffice.deliver_todo_unchecked(self, self.user, current_user) unless self.user == current_user# => notify the creator
    self.shares.each do |share|
      Postoffice.deliver_todo_unchecked(self, share.user, current_user) unless share.user == current_user # and everyone else
    end
  end
end
