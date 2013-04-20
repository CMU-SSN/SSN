class PostsController < ApplicationController
  before_filter :authenticate_user!
  # GET /posts
  # GET /posts.json
  def index
    # Filter all posts for the current user that happened after the specified token
    filter()

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def refresh
    # when load older pages should specify this
    if (params['backward'] == 'true')
      filter(true)
    else
      filter()
    end

    respond_to do |format|
      format.html { render :partial => "partials/refresh" }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    setupForNewPost

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/checkin
  def checkin

    setupForNewPost

    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end

  # GET /post_contect?id=
  def post_context
    session[:post_as] = params[:id]

    respond_to do |format|
      format.json { render :json => {:status => 200} }
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    if session[:post_as] == 'self'
      current_user.posts.create!(params[:post])
    else
      post = current_user.posts.build(params[:post])
      post.organization = current_user.organizations.where("organization_id = ?", session[:post_as]).first
      post.save
    end

    respond_to do |format|
      flash[:notice] = "Post created successfully!"
      format.html { redirect_to '/posts#index', notice: 'Post was successfully created.' }
      format.json { render json: @post, status: :created, location: @post }
    end
  end

  def where_am_i
    result = Geocoder.search([params['latitude'].to_f, params['longitude'].to_f])

    address = result.first.address if !result.nil? && result.count > 0
    respond_to do |format|
      format.json {render :json => {:address => result.first.address}}
    end
  end

  def setupForNewPost
    @post = Post.new

    # Get the post as variable from the sesssion.  If it doesn't exist,
    # set it to Post::POST_AS_SELF
    if session[:post_as].nil?
      session[:post_as] = Post::POST_AS_SELF
    end

    @post_as = session[:post_as]

  end

  def filter(older = false)
    if (!params['latitude'].nil? && !params['longitude'].nil?)
      location = [params['latitude'].to_f, params['longitude'].to_f]
    elsif (!params['location'].nil?)
      location = params['location']
    end
    token = params['token']
    token = {:id => token, :backward => true} if older
    @max_distance = Post.max_distance_from_position(current_user, location)
    @posts = Post::Filter(current_user, 5, token, location, params['radius'])
    @token = @posts.first.id if !@posts.nil? && !@posts.first.nil?
    @last_token = @posts.last.id if !@posts.nil? && !@posts.last.nil?
    @path = "../"
  end
	
	def reloadPosts
		filter()
	end
end
