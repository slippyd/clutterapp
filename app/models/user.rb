require 'digest/sha1'

class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 6..40
  validates_uniqueness_of   :login,    :message => %<"{{value}}" has already been taken>
  
  validates_length_of       :name,     :maximum => 100
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :message => %<"{{value}}" has already been taken>
  
  
  # derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
  
  #validates_presence_of   :invite_id, :message => 'is required'
  validates_uniqueness_of :invite_id, :allow_nil => true
  
  has_many :sent_invites, :class_name => 'Invite', :foreign_key => 'sender_id'
  belongs_to :invite
  
  before_create :set_starting_invite_limit
  
  
  #before_validation_on_create :create_default_pile!
  after_create :default_pile # ensures that it's created
  
  #Followship associations
  has_many :followships
  has_many :followees, :through => :followships
  has_many :users, :through => :followships
  
  has_many :piles, :foreign_key => 'owner_id', :dependent => :destroy, :autosave => true
  
  
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :invite_token
  
  
  
  def to_param
    login
  end
  
  #Followship methods
  def add_followee(followee)
    followship = followships.build(:user_id => self.id, :followee_id => followee.id)
    unless followship.save
      logger.debug "User #{followee.login} is already the users friend."
    end
  end
  
  def remove_followee(followee)
    followship = Followship.find_by_user_and_followee(self, followee)
    followship.destroy if followship
  end
  

  
  def is_followee?(followee)
    self.followees.include? followee
  end
  
  def follows
    User.find_follows self
  end
  

  
  # derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
  def invite_token
    invite.token if invite
  end
  
  def invite_token=(token)
    self.invite = Invite.find_by_token(token)
  end
  
  
  def invites_remaining
    if invite_limit.nil?
      (1.0/0.0) # infinity
    else
      invite_limit - invite_sent_count
    end
  end
  
  
  
  def default_pile
    @default_pile ||= piles.first || create_default_pile
  end
  
  
protected
  
  DEFAULT_INVITATION_LIMIT = (1.0/0.0) # infinity
  
  def set_starting_invite_limit
    self.invite_limit = DEFAULT_INVITATION_LIMIT
  end
  
  def create_default_pile
    @default_pile = Pile.create(:owner => self, :name => "#{self.name}'s Pile") unless piles.count > 0
  end
  
  def create_default_pile!
    raise Exception.new('A default Pile could not be created because one for this User already exists.') if piles.count > 0
    create_default_pile
  end
  
  def self.find_follows(user)
    Followship.find(:all, :conditions => ["followee_id = ?", user.id]).map{|f|f.user}
  end
  
end