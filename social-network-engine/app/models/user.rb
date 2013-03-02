class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :profile_pic, :email, :password, :password_confirmation, :remember_me, :token_expiration, :provider, :uid, :token
  has_many :posts, :dependent => :destroy
  has_many :friends
  has_and_belongs_to_many :organizations

  def ImportFriends(facebook_friend_ids)
    # Look for existing users in specified Facebook friends
    facebook_friend_ids.each do |i|
      # TODO(vmarmol): Do all these lookups at once.
      potential_friend = User.find_by_uid(i)

      # Add friends that exist
      if not potential_friend.nil?
        self.friends << Friend.new(:user =>self, :friend => potential_friend)
      end
    end
  end
end
