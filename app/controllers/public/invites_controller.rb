class InvitesController < ApplicationController
  def index
    @invites = Invite.all
  end
  
  def show
    @invite = Invite.find(params[:id])
  end
  
  def new
    @invite = Invite.new
  end
  
  def create
    @invite = Invite.new(params[:invite])
    if @invite.save
      flash[:notice] = "Successfully created invite."
      redirect_to @invite
    else
      render :action => 'new'
    end
  end
  
  def edit
    @invite = Invite.find(params[:id])
  end
  
  def update
    @invite = Invite.find(params[:id])
    if @invite.update_attributes(params[:invite])
      flash[:notice] = "Successfully updated invite."
      redirect_to @invite
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy
    flash[:notice] = "Successfully destroyed invite."
    redirect_to invites_url
  end
end
