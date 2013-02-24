class SearchController < ApplicationController
  def search
    @query = params[:q]
    @results = nil

    print "\n\n\nSearch |"+@query.to_s+"|\n\n\n"

    # Search if a query was specified
    if not @query.nil? and not @query.strip().empty?
      @result = []

      # Search users
      user_query = "%#{@query}%"
      @results = User.find(:all, :limit => 50, :conditions => ["name LIKE ?", user_query])
      @results.map!{|u| SearchResult::CreateUserResult(u)}
    end
  end
end
