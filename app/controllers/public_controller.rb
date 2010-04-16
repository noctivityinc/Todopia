class PublicController < ApplicationController
  before_filter :login_required
  layout 'public'
  
  def index
    redirect_to user_todos_path(current_user)
  end

end
