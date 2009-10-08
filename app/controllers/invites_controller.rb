# derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
class InvitesController < ApplicationController
  
  def new
    @invite = Invite.new
  end
  
  
  def create
    @invite = Invite.new(params[:invite])
    @invite.sender = current_user
    
    unless @invite.save
      render :action => 'new'
    
    else
      if logged_in?
        Mailer.deliver_invite(@invite, new_user_url(@invite.token))
        flash[:notice] = "Thanks! Invite sent."
        redirect_to new_invite_url
      else
        flash[:notice] = "Thanks! We'll let you know when our little bun is out of the oven!"
        redirect_to root_url
      end
    end
  end
  
end