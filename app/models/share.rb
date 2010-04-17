# == Schema Information
# Schema version: 20100416215105
#
# Table name: shares
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  tag          :string(255)
#  sharee_id    :integer
#  can_complete :boolean
#  invite_id    :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Share < ActiveRecord::Base
end
