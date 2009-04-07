class UsersController < ApplicationController
  
  # render new.rhtml
  def new
    # derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
    @user = User.new(:invite_token => params[:invite_token])
    @user.email = @user.invite.recipient_email if @user.invite
  end
  
  
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  
  # render show_pile.rhtml
  def show_pile
    @piles_owner = User.find_by_login(params[:user_login])
    if @piles_owner.nil?
      flash[:error] = "Sorry, we know of no such user."
      redirect_to home_url
    elsif current_user == @piles_owner
      @root_node = current_user.pile.root_node
    else
      flash[:warning] = "You can't really see this pile since, well, it's not yours. Maybe someday though."
    end
  end
  
end
