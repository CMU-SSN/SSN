class UsersController < ApplicationController
  before_filter :authenticate_user! 
  def show
		@user = User.find(params[:id])
		@posts = @user.posts.reverse

		@path = "../"
    respond_to do |format|
      format.html # show.html.erb
    end
  end
	
  # POST followUser/?id=
  def add_friend
		user = User.find(params[:id])
		if !current_user.friends.include?(user)	
			current_user.friends << User.find(params[:id])
		end
		respond_to do |format|
      format.json { head :ok }
    end
  end
	
	# POST removeUser/?id=
  def remove_friend
		user = User.find(params[:id])
		if current_user.friends.include?(user)	
			current_user.friends.delete(User.find(params[:id]))
		end
		respond_to do |format|
      format.json { head :ok }
    end
  end
	
	def followings
		@user = User.find(params[:id])
		@path = "../"
		@feedItemId = "followingFeedItemId"
	end
	
	def followers
		@user = User.find(params[:id])
		@path = "../"
		@feedItemId = "userFollowerFeedItemId"
	end
	
	def posts
		@user = User.find(params[:id])
		@posts = @user.posts.reverse
		@path = "../"
	end
	
	def organizations
		@user = User.find(params[:id])
		@path = "../"
		if(current_user == @user)
			@feedItemId = "followingFeedItemId"
		end
	end

	def voip_start
		@user = User.find(params[:id])
		voip_user_check(@user)
	end

	# voip_register:
	# Assign VoIP extension from the first number to
	# the last number consecutively (e.g. 401-600)
	def voip_register
		@user = User.find(params[:id])
		if voip_user_check(@user)
			first = 400 # The first extension assigned
			last = 600 # The largest extension assigned
			assigned = User.maximum("voip_ext") # The largest currently assigned extension

			if assigned.nil?
				@user.voip_ext = first
			elsif assigned == last
				# Todo: redirect to error message
			else
				@user.voip_ext = assigned + 1
				@user.save
			end
		end
	end

	# voip_user_check:
	# Check if the user is adding VoIP extension to its own account
	# and s/he does not have extension yet
	def voip_user_check(user)
		if user != current_user || !(user.voip_ext.nil?)
			redirect_to root_path
			return false
		else
			return true
		end
	end
end