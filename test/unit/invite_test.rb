require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  should "be valid" do
    assert Invite.new.valid?
  end
end
