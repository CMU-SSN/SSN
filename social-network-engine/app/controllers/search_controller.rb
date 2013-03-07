class SearchController < ApplicationController
  before_filter :authenticate_user!

  # TODO(vmarmol): The fact that I have to put to_i everywhere lets me know I don't know Ruby's "magic"

  def search
    @query = params[:q]
    @type = params[:type]
    @page_num = params[:page]
    @results = nil

    # Default to posts
    if @type.nil? or @type.empty?
      @type = SearchResult::Type::POST
    end

    # Default to 0th page
    if @page_num.nil? or @page_num.empty?
      @page_num = 0
    end

    # Search if a query was specified
    if not @query.nil? and not @query.strip().empty?
      @results = []
      offset = @page_num.to_i * SearchResult::PAGE_SIZE.to_i
      # Fetch one more (which we won't displays so that we know if we can page)
      limit = SearchResult::PAGE_SIZE.to_i + 1

      # Search posts
      if @type.to_i == SearchResult::Type::POST.to_i
        post_query = "%#{@query}%"
        @results = Post.includes([:user, :organization]).find(:all, :limit => limit, :conditions => ["text LIKE ?", post_query], :order => "created_at DESC", :offset => offset)
        @results.map!{|p| SearchResult::CreatePostResult(p)}
      end

      # Search users
      if @type.to_i == SearchResult::Type::USER.to_i
        user_query = "%#{@query}%"
        @results = User.find(:all, :limit => limit, :conditions => ["name LIKE ?", user_query], :offset => offset)
        @results.map!{|u| SearchResult::CreateUserResult(u)}
      end

      # Search organizations
      if @type.to_i == SearchResult::Type::ORGANIZATION.to_i
        org_query = "%#{@query}%"
        @results = Organization.find(:all, :limit => limit, :conditions => ["name LIKE ?", org_query], :offset => offset)
        @results.map!{|o| SearchResult::CreateOrganizationResult(o)}
      end
    end
  end
end
