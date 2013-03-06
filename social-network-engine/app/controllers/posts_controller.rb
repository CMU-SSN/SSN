class PostsController < ApplicationController
  before_filter :authenticate_user!
  # GET /posts
  # GET /posts.json
  def index
    # Filter all posts for the current user that happened after the specified token
    @posts = Post::Filter(current_user, 100, params['token'])
    @token = @posts.first.id if !@posts.nil? && !@posts.first.nil?
    
    if session[:post_as].nil?
      session[:post_as] = 'self'
    end
    
    @post_as = session[:post_as]

    @post = Post.new

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def refresh
    @posts = Post::Filter(current_user, 100, params['token'])
    @token = @posts.first.id if !@posts.nil? && !@posts.first.nil?
    respond_to do |format|
      format.html {render :partial=>"partials/refresh"}
    end
  end
  
  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end
  
  # GET /post_contect?id=
  def post_context
    session[:post_as] = params[:id]
    
    respond_to do |format|
       format.json { render :json => { :status => 200 } }
     end
  end

  # POST /posts
  # POST /posts.json
  def create
    if session[:post_as] == 'self'
      current_user.posts.create!(params[:post])
    else
      print session[:post_as]
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
end
