require 'spec_helper'

describe Followship do
  dataset :users
  
  
  before(:each) do
    activate_authlogic
    @user = users(:a_user)
    @pile = @user.default_pile
  end
  
  describe "Finding followships" do
    it "should create a followship between a user and a followee" do
      followship = Followship.create(:user_id => users(:a_user).id, :followee_id => @user.id)
      followship.should be_valid
    end
  end
end