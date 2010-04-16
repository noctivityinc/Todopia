require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  context "index action" do
    should "render index template" do
      get :index
      assert_template 'index'
    end
  end
  
  context "show action" do
    should "render show template" do
      get :show, :id => Note.first
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
      Note.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Note.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to note_url(assigns(:note))
    end
  end
  
  context "edit action" do
    should "render edit template" do
      get :edit, :id => Note.first
      assert_template 'edit'
    end
  end
  
  context "update action" do
    should "render edit template when model is invalid" do
      Note.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Note.first
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Note.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Note.first
      assert_redirected_to note_url(assigns(:note))
    end
  end
  
  context "destroy action" do
    should "destroy model and redirect to index action" do
      note = Note.first
      delete :destroy, :id => note
      assert_redirected_to notes_url
      assert !Note.exists?(note.id)
    end
  end
end
