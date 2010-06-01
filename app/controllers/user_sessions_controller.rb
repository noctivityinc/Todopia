class UserSessionsController < ApplicationController
  layout 'public'

  def new
    debugger
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Logged in successfully."
      cookies[:tags] = nil
      redirect_to_target_or_default (user_todos_path(current_user))
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy if @user_session
    flash[:notice] = "You have been logged out."
    redirect_to login_url
  end
end
