class Public::UsersController < PublicController
  skip_before_filter :login_required

  def new
    @user = User.new
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
  
  def email
    @user = User.find(params[:id])
    return unless @user
    flash.notice = "Todos emailed to #{@user.email}." if Postoffice.deliver_email_todos(@user)
    render :text => nil
  end
end
