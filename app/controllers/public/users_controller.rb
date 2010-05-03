class Public::UsersController < PublicController
  skip_before_filter :login_required, :only => [:new, :create]
  before_filter :get_user, :except => [:new, :create]

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Thank you for signing up! You are now logged in."
      redirect_to user_todos_path(@user)
    else
      render :action => 'new'
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash.notice = "Your account has been updated"
      redirect_to user_todos_path(@user)
    else
      render :edit
    end
  end

  def email
    return unless @user
    flash.notice = "Todos emailed to #{@user.email}." if Postoffice.deliver_email_todos(@user, true)  # => forcing the delivery of all todos, regardless of over due status
    render :text => nil
  end

  def send_reset_password_email
    @user.deliver_password_reset_instructions!
    flash.notice = "Instructions to reset your password have been emailed to you. " +
    "Please check your email and spam folder now."
    redirect_to user_todos_path(@user)
  end

  private

  def get_user
    @user = User.find(params[:id])
    unless @user
      flash.error = "Unauthorized access!"
      redirect_to root_url
    end
  end
end
