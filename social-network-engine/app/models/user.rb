class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :profile_pic, :email, :password, :password_confirmation, :remember_me, :token_expiration, :provider, :uid, :token
  has_many :posts, :dependent => :destroy
  has_many :potential_friends
  has_many :friends

  def ImportFriends(facebook_friend_ids)
    # Look for existing users in specified Facebook friends
    facebook_friend_ids.each do |i|
      potential_friend = User.find_by_uid(i)

      # Unknown friends are potential friends, known users are friends
      if potential_friend.nil?
        self.potential_friends << PotentialFriend.new(:user => self,
            :friend_facebook_id => i)
      else
        self.friends << Friend.new(:user =>self, :friend => potential_friend)
      end
    end

    # Look for self in PotentialFriends and turn into a Friend.
    found_friends = PotentialFriend.find(:all,
        :conditions => ["friend_facebook_id =?", self.uid])
    if not found_friends.nil?
      # Move from PotentialFriend to Friend
      found_friends.each do |i|
        i.user.friends << Friend.new(:user => i.user, :friend => self)
        PotentialFriend.destroy_all(:user_id => i.user.id,
            :friend_facebook_id => self.uid)
      end
    end
  end
end
