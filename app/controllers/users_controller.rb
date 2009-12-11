class UsersController < ApplicationController
  before_filter :authorize, :except => [:new, :create]
  
  # render new.rhtml
  def new
    # derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
    @user = User.new(:invite_token => params[:invite_token])
    @user.email = @user.invite.recipient_email if @user.invite
  end
  
  
  def create
    @user = User.new(params[:user])
    
    unless params[:signup_code] == current_signup_code
      flash[:error]  = "Na na na! Na na na! That's not the correct sign-up code! Na na na…"
      return render :action => 'new'
    end
    
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery protection if visitor resubmits an earlier form using back button. Uncomment if you understand the tradeoffs.
      # reset session
      current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up! Enjoy organizing your clutter!"
      logger.prefixed 'USER', :light_yellow, "New user '#{@user.login}' created from #{request.remote_ip} at #{Time.now.utc}"
    else
      flash[:error]  = "We couldn't set up that account, sorry. Please try again, or contact an admin."
      render :action => 'new'
    end
  end
  
  
  def show
    @user = User.find_by_login(params[:id])
    
    if !@user.nil?
      @public_piles = [] #@user.piles # @todo: make it actually show only public piles, once they're implemented
      @shared_piles = []
      render # show.html.erb
      
    else
      flash[:error]  = %{Couldn't find user by the name of "#{params[:id]}".}
      redirect_to home_path
    end
  end
  
  
protected
  
  def current_signup_code
    today = Date.today
    
    first_letter_of_day_of_week = today.strftime('%A')[0,1]
    last_digit_of_day_of_month = today.strftime('%d')[1,1]
    first_letter_of_month = today.strftime('%b')[0,1]
    last_digit_of_year = today.strftime('%Y')[3,1]
    
    secret_code = first_letter_of_day_of_week + last_digit_of_day_of_month + '-' + first_letter_of_month + last_digit_of_year
    "#{secret_code}"
  end
  
end
