class NodeController < ApplicationController

  # Registers a node and allows existing nodes to update their registration.
  # On a successful registration it outputs a random UID for the node. The node
  # can then use that UID to update its entry.
  #
  # To create an entry:
  #
  #   /register?name=<NAME>&latitude=<LATITUDE>&longitude=<LONGITUDE>&hostname=<HOSTNAME>
  #
  # To update an entry:
  #
  #   /register?uid=<UID>&<any params that you want to update>
  def register
    link =  params[:hostname]
    if not link.nil?
      link += "/signup"
    end

    uid = params[:uid]
    if uid.nil? or uid.empty?
      # New node
      node = Node.new(
          :name =>  params[:name],
          :latitude => params[:latitude],
          :longitude => params[:longitude],
          :link => link,
          :uid => SecureRandom.urlsafe_base64(20),
          :checkin => DateTime.now)
    else
      # Old node, get and update
      node = Node.find_by_uid(uid)
      if node.nil?
        render :json => { :success => false, :errors => ["Unknown UID"]}
      end

      # Update name, lat, long, and link only
      attrs = {}
      attrs[:name] = params[:name]
      attrs[:latitude] = params[:latitude]
      attrs[:longitude] = params[:longitude]
      attrs[:link] = params[:hostname] + "/signup" unless  params[:hostname].nil?

      # Register the checkin
      attrs[:checkin] = DateTime.now
      node.update_attributes(attrs)
    end

    if node.save
      render :json => { :success => true, :uid => node.uid }
    else
      render :json => { :success => false, :errors => node.errors }
    end
  end

  # Searches for nodes that are within 5 miles of the specified query location.
  # Implements paging for the results.
  # TODO(vmarmol): Downrank those that have not been updated in a while
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
