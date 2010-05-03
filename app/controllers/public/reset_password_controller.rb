class Public::ResetPasswordController < PublicController
  skip_before_filter :login_required
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new
    render
  end

  def create
    @user = User.find_by_email(params[:email]) unless params[:blank]
    if @user
      @user.deliver_password_reset_instructions!
      flash.notice = "Instructions to reset your password have been emailed to you. " +
      "Please check your email and spam folder now."
      redirect_to login_path
    else
      flash.error = "Sorry but we could not find an account for that email address."
      render :action => :new
    end
  end

  def edit
    render
  end

  def update
    if !params[:user][:password].blank? && @user.update_attributes(params[:user])
      flash[:notice] = "Password successfully updated"
      @user_session = UserSession.new(@user)
      @user_session.save
      redirect_to user_todos_path(@user)
    else
      render :edit
    end
  end

  private
  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry, but that password reset link is no longer valid. " +
      "If you are still having troubles accessing your account then please reset your password " +
      "by entering your email below.  If something else, please contact support. "
      redirect_to root_url
    end
  end

end
