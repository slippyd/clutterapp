require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  
  
protected
  
  def create_user(options = {})
    invite = Invite.new(:recipient_email => '')
    invite.save_with_validation(false)
    
    record = User.new({
      :login => 'quiree',
      :email => 'quire@example.com',
      :password => 'quire69',
      :password_confirmation => 'quire69',
      :invite_token => invite.token
    }.merge(options))
    record.save # normal save to create piles
    record
  end
  
end
