class NodeController < ApplicationController
  def register
  end

  def search
    @query = params[:q]
    @page_num = params[:page]
    @results = nil

    # Start at the first page
    if @page_num.nil? or @page_num.empty?
      @page_num = 0
    end

    if not @query.nil? and not @query.strip().empty?
      offset = @page_num.to_i * NodeHelper::PAGE_SIZE.to_i

      # Get the results
      @results = Node.near(@query, 5)

      # Sort by distance
      @results.sort!{|a,b| a.distance <=> b.distance}

      # Only keep a page of results
      @results = @results.slice(offset, NodeHelper::PAGE_SIZE.to_i + 1)
    end

    render('search')
  end
end
