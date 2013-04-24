class StatusController < ApplicationController
  before_filter :authenticate_user!
  def index
    @status = current_user.status
    @statuses = Status.includes(:user).where("status in (?)", [Post::NEEDS_ASSISTANCE_STATUS, Post::NEEDS_HELP_STATUS]).order("status DESC").map do |status|
      status.clear = true if status.user.id == current_user.id
      status
    end
    @path = "../"
  end

  def create
    @status = params[:status]
    unless current_user.status.nil?
      current_user.status.update_attributes(@status)
    else
      current_user.create_status(@status)
    end

    respond_to do |format|
      format.html {redirect_to status_path}
    end
  end

  def destroy
  end
end
