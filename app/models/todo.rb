# == Schema Information
# Schema version: 20100414145449
#
# Table name: todos
#
#  id           :integer         not null, primary key
#  label        :string(255)
#  position     :integer
#  completed_at :datetime
#  user_id      :integer
#  completed_by :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Todo < ActiveRecord::Base
  attr_accessor :completed, :tag_string
  acts_as_taggable_on :tags
  
  has_many :notes, :dependent => :destroy
  has_many :histories, :dependent => :destroy
  belongs_to :user
  belongs_to :completer, :class_name => "User", :foreign_key => "completed_by"
  
  validates_presence_of :label
  validates_length_of :label, :within => 2..255, :unless => Proc.new {|todo| todo.label.blank? } 
  validates_format_of :label, :with => /[^\+\sAdd\snew\stodo]/, :on => :create, :message => "is invalid"
  
  named_scope :not_complete, :conditions => ['completed_at IS ?', nil], :order => 'position ASC, created_at DESC'
  named_scope :complete, :conditions => ['completed_at IS NOT ?', nil], :order => 'completed_at DESC'
  
  before_create :set_position
  before_save :tag_string_to_tag_list
  before_update :check_completed
  
  private
  
  def set_position
    self.position = 0
  end
  
  def tag_string_to_tag_list
    self.tag_list = self.tag_string.downcase unless self.tag_string.blank?
  end
  
  def check_completed
    self.completed_at = Time.now if self.completed
  end
  
end
