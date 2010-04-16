require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  should "be valid" do
    assert Todo.new.valid?
  end
end
