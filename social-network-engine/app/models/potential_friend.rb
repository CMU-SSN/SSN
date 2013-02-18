class PotentialFriend < ActiveRecord::Base
  attr_accessible :friend_facebook_id, :user_id

  belongs_to :user
end
