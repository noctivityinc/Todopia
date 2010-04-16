require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end
  
  context "create action" do
    should "render new template when authentication is invalid" do
      post :create, :user_session => { :login => "foo", :password => "badpassword" }
      assert_template 'new'
      assert_nil UserSession.find
    end
    
    should "redirect when authentication is valid" do
      post :create, :user_session => { :login => "foo", :password => "secret" }
      assert_redirected_to root_url
      assert_equal users(:foo), UserSession.find.user
    end
  end
end
