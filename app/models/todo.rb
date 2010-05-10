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
  attr_accessor :completed, :tag_string
  acts_as_taggable_on :tags

  has_many :notes, :dependent => :destroy
  has_many :histories, :dependent => :destroy
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

  def toggle_waiting
    self.waiting_since = (self.waiting_since ? nil : Time.now)
    self.save
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

  def tag_string_to_tag_list
    self.tag_list = filter_plugins.downcase unless self.tag_string.blank?
  end

  def check_completed
    self.completed_at = Time.now if self.completed
  end

  def filter_plugins
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
      if !tag.scan(/^(start|begin)s?(\s[at|on])?\s(.*)\b/).empty?
        self.starts_at = Chronic.parse(tag)
      elsif tag =~ /^(due|by)\s(.*)/i
        self.due_date = Chronic.parse(tag.match(/^(due|by)\s(.*)/i)[2])
      elsif Chronic.parse(tag)
        self.due_date = Chronic.parse(tag)
      elsif tag.starts_with? '#'
        tag[1] == '!' ? (self.highlight = true) : (self.priority = tag[1..-1])
      end
    }

    self.starts_at = self.due_date if self.starts_at && self.due_date && self.due_date < self.starts_at # => prevents setting a due date before the event starts
  end

  def post_tag_plugins
    return unless self.tag_string
    self.tag_string.downcase.split(',').each {|tag| tag.strip!; self.user.tag_groups.create(:tag => tag[1..-1]) if tag.starts_with? '!' }
  end


end
