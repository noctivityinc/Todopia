# == Schema Information
# Schema version: 20100421004421
#
# Table name: todos
#
#  id              :integer         not null, primary key
#  label           :string(255)
#  priority        :integer
#  completed_at    :datetime
#  user_id         :integer
#  completed_by_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  due_date        :date
#  waiting_since   :datetime
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

  named_scope :not_complete, :conditions => ['completed_at IS ?', nil], :order => 'waiting_since DESC, priority ASC, created_at DESC'
  named_scope :complete, :conditions => ['completed_at IS NOT ?', nil], :order => 'completed_at DESC'

  before_create :set_priority
  before_save :set_completed_by_id, :tag_string_to_tag_list, :pre_tag_plugins
  before_update :check_completed

  after_save :post_tag_plugins
  
  def toggle_waiting
    self.waiting_since = (self.waiting_since ? nil : Time.now)
    self.save
  end

  private

  def not_labelify_label
    if self.label.strip == '+ Add new todo'
      errors.add('label','cannot be blank')
      return false
    end
  end

  def set_priority
    self.priority = 10
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
      if %w{! @ #}.include? tag[0]
        tag[1..-1]
      else
        tag if !Chronic.parse(tag)
      end
    end.join(',')
  end

  def pre_tag_plugins
    return unless self.tag_string
    self.tag_string.split(',').each { |tag| self.due_date = Chronic.parse(tag) if Chronic.parse(tag) }
    self.tag_string.split(',').each {|tag| self.priority = tag[1..-1] if tag.starts_with? '#' }
  end

  def post_tag_plugins
    return unless self.tag_string
    self.tag_string.downcase.split(',').each {|tag| self.user.tag_groups.create(:tag => tag[1..-1]) if tag.starts_with? '!' }
  end



end
