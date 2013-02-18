class PotentialFriend < ActiveRecord::Base
  attr_accessible :friend_facebook_id, :user

  belongs_to :user
end
