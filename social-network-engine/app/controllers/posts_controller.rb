class PostsController < ApplicationController
  before_filter :authenticate_user!
  # GET /posts
  # GET /posts.json
  def index
    # Filter all posts for the current user that happened after the specified token
    @posts = Post::Filter(current_user, 100, params['token'])

    posts = @posts.collect do |post|
      {:text => post.text,
       :creator_name => post.user.name,
       :creator_pic => post.user.profile_pic,
       :updated_at => post.updated_at,
       :city => post.city,
       :zipcode => post.zipcode}
    end

    @token = @posts.first.id if !@posts.nil? && !@posts.first.nil?


    @post = Post.new

    respond_to do |format|
      format.html # index.html.erb
      format.json do
        render :json => {:code => 200, :data => posts, :token => @token}
      end
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
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

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    current_user.posts.create! params[:post]

    respond_to do |format|
      flash[:notice] = "Post created successfully!"
      format.html { redirect_to '/posts#index', notice: 'Post was successfully created.' }
      format.json { render json: @post, status: :created, location: @post }
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
