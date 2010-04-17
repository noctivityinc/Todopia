# == Schema Information
# Schema version: 20100416215105
#
# Table name: invites
#
#  id          :integer         not null, primary key
#  inviter_id  :integer
#  email       :string(255)
#  name        :string(255)
#  token       :string(255)
#  accepted_at :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Invite < ActiveRecord::Base
  attr_accessible :inviter_id, :email, :name, :token, :accepted_at
end
