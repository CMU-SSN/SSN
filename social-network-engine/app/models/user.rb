class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :profile_pic, :email, :password, :password_confirmation, :remember_me, :token_expiration, :provider, :uid, :token
  has_many :posts, :dependent => :destroy

  # The user's friends
  has_and_belongs_to_many :friends, :class_name => "User", :foreign_key => "user_id", :association_foreign_key => "friend_id", :join_table => "friends_users"

  # The organizations the user administers
  has_and_belongs_to_many :organizations

  def ImportFriends(facebook_friend_ids)
    self_friends = self.friends
    # Look for existing users who are Facebook friends
    User.find(:all, :conditions => ["uid IN (?)", facebook_friend_ids]).each do |potential_friend|

      # Add friends that aren't my friends already
      if self_friends.index{|f| f.id == potential_friend.id}.nil?
        self.friends << potential_friend
      end
    end
  end
end
