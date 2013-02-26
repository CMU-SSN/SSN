class SearchController < ApplicationController
  before_filter :authenticate_user!

  def search
    @query = params[:q]
    @type = params[:type]
    @results = nil

    # Default to posts
    if @type.nil? or @type.empty?
      @type = SearchResult::Type::POST
    end

    # Search if a query was specified
    if not @query.nil? and not @query.strip().empty?
      @results = []

      # Search posts
      if @type.to_i == SearchResult::Type::POST.to_i
        post_query = "%#{@query}%"
        @results = Post.find(:all, :limit => 50, :conditions => ["text LIKE ?", post_query], :order => "created_at DESC")
        @results.map!{|p| SearchResult::CreatePostResult(p)}
      end

      # Search users
      if @type.to_i == SearchResult::Type::USER.to_i
        user_query = "%#{@query}%"
        @results = User.find(:all, :limit => 50, :conditions => ["name LIKE ?", user_query])
        @results.map!{|u| SearchResult::CreateUserResult(u)}
      end

      # Search organizations
      if @type.to_i == SearchResult::Type::ORGANIZATION.to_i
        # TODO: Search when they exist
      end
    end
  end
end
