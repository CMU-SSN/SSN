class OrganizationsController < ApplicationController
  before_filter :authenticate_user!
  def show	
		@organization = Organization.find(params[:id])
		@posts = @organization.posts.reverse
		@path = "../"
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
