require 'test_helper'

class HistoryTest < ActiveSupport::TestCase
  should "be valid" do
    assert History.new.valid?
  end
end
