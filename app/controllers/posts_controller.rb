class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :report]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorized_user, only: [:edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    limit = params[:page] || 1 
    if params[:type].present? and params[:type] == 'challenge'
      @posts = Post.where(post_type: 'challenge').order(created_at: :desc).page limit
    elsif params[:type].present? and params[:type] == 'regular'
      @posts = Post.where(post_type: 'regular').order(created_at: :desc).page limit
    elsif params[:type].present? and params[:type] == 'external'
      @posts = Post.where(post_type: 'external').order(created_at: :desc).page limit
    else
      @posts = Post.order(created_at: :desc).page limit
    end
    respond_to do |format|
      format.html { 
        render layout: nil, action: "_post_list" if params[:page].present?
      }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
    @post.post_id = params[:id] 
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)
    @post.admin = true if current_user.admin?
    respond_to do |format|
      if @post.save

        # current user progress
        @progess = Progress.where(user_id: current_user).first

        if not (@progess)
          Progress.create(user_id: current_user.id)
          @progess = Progress.where(user_id: current_user).first
        end

        @progess.increment(Progress.get_progress_val(post_params[:post_type]))
        @progess.save

        if @post.parent.present? and @post.parent.challenge? and @post.parent.user.id != current_user.id
          #Challenger poster progress 1 / 2
          # current user progress
          progess = Progress.where(user_id: @post.parent.user.id).first

          if not (progess)
            progess =  Progress.create(user_id: @post.parent.user.id)
          end

          progess.increment( ( 1.to_f / 2.to_f ).to_f )
          progess.save
        end

        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def report
    redirect_to root_path, alert: "Post not found" and return if @post.blank?
    if session[:report_posts].present? and !session[:report_posts].include?(@post.id)
      session[:report_posts] = [@post.id]
      ReportMailer.report_post(@post, current_user).deliver
    else
      if session[:report_posts].blank?
        session[:report_posts] = [@post.id]
        ReportMailer.report_post(@post, current_user).deliver
      end
    end
    redirect_to root_path, alert: "Post reported successfully!"
  end

  def upvote
    @post = Post.find(params[:id])
    @post.upvote_by current_user
    if current_user.votes.up.by_type(Post).count >= 1
      current_user.user_badges.create(:badge_id => 3) if current_user.user_badges.where(:badge_id => 3).first.blank?
    end
    if request.xhr?
      respond_to do |format|
        format.js
      end
      # respond to Ajax request
    else
      redirect_to :back
    end
    
  end

  def downvote
    @post = Post.find(params[:id])
    @post.downvote_from current_user
    redirect_to :back
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  def authorized_user
    if ( current_user and current_user.admin? )
      @post = Post.find_by(id: params[:id])
    else
      @post = current_user.posts.find_by(id: params[:id])
    end
    redirect_to posts_path, notice: "Not authorized to edit this post" if @post.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:id, :title, :url, :description, :image, :expiry_date, :post_type, :post_id)
  end
end
