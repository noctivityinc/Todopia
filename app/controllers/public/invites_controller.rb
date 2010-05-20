class Public::InvitesController < PublicController
  skip_before_filter :login_required

  def show
    invite = Invite.find_by_token(params[:id])
    if invite
      session[:invite_id] = invite.id
      flash.notice = "You need to create an account to access this todo."
    else
      flash.error = "That invite is no longer valid, but you can still signup for an account."
    end
    redirect_to signup_path
  end

end
