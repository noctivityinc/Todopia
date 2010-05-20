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

  after_save :notify_others, :if => Proc.new {|note| note.todo.shared?}

  private

  def notify_others
    Postoffice.deliver_note_added(self, self.todo.user) unless self.todo.user == self.user # => notify the creator unless they wrote the note
    self.todo.shares.each do |share|
      Postoffice.deliver_note_added(self, share.user) unless share.user == self.user # and everyone else unless they wrote the note
    end
  end
end
