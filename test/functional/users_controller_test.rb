require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end
  
  context "create action" do
    should "render new template when model is invalid" do
      User.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
  
    should "redirect when model is valid" do
      User.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to root_url
    end
  end
end
