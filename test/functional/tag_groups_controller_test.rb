require 'test_helper'

class TagGroupsControllerTest < ActionController::TestCase
  context "index action" do
    should "render index template" do
      get :index
      assert_template 'index'
    end
  end
  
  context "show action" do
    should "render show template" do
      get :show, :id => TagGroup.first
      assert_template 'show'
    end
  end
  
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end
  
  context "create action" do
    should "render new template when model is invalid" do
      TagGroup.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      TagGroup.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to tag_group_url(assigns(:tag_group))
    end
  end
  
  context "edit action" do
    should "render edit template" do
      get :edit, :id => TagGroup.first
      assert_template 'edit'
    end
  end
  
  context "update action" do
    should "render edit template when model is invalid" do
      TagGroup.any_instance.stubs(:valid?).returns(false)
      put :update, :id => TagGroup.first
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      TagGroup.any_instance.stubs(:valid?).returns(true)
      put :update, :id => TagGroup.first
      assert_redirected_to tag_group_url(assigns(:tag_group))
    end
  end
  
  context "destroy action" do
    should "destroy model and redirect to index action" do
      tag_group = TagGroup.first
      delete :destroy, :id => tag_group
      assert_redirected_to tag_groups_url
      assert !TagGroup.exists?(tag_group.id)
    end
  end
end
