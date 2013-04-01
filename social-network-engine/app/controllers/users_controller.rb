class UsersController < ApplicationController
  before_filter :authenticate_user! 
  def show
		@user = User.find(params[:id])
		@posts = @user.posts.reverse
		@posts.delete_if {|post| post.organization != nil}
		
		@path = "../"
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
