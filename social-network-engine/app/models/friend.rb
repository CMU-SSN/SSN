class Friend < ActiveRecord::Base
  attr_accessible :user, :friend
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
end
