class UsersController < ApplicationController
  before_action :authenticate_user!

  def staff_picked
    @user = User.find_by_id(params[:id])
    redirect_to root_path and return if @user.blank?
    redirect_to root_path and return unless current_user.admin?
    if @user.user_badges.where(:badge_id => 13).first.blank?
      @user.user_badges.create(:badge_id => 13)
      flash[:success] = "Successfully assigned badged!"
    else
      flash[:error] = "Badge is already assigned to this user"
    end
    redirect_to :back and return
  end


  def like
    @user = User.find_by_id(params[:id])
    redirect_to root_path and return if @user.blank?
    redirect_to :back and return if @user.id == current_user.id

    if current_user.voted_up_on? @user
      @user.downvote_by current_user
    else
      @user.upvote_by current_user
    end

    if current_user.votes.up.for_type(User).count >= 1000
      current_user.user_badges.create(:badge_id => 14) if current_user.user_badges.where(:badge_id => 14).first.blank?
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


  def show
    @user = User.find_by_id(params[:id])
    redirect_to root_path and return if @user.blank?

    limit = params[:page] || 1
    if params[:type].present? and params[:type] == 'challenge'
      @posts = @user.posts.where(post_type: 'challenge').order(created_at: :desc).page limit
    elsif params[:type].present? and params[:type] == 'regular'
      @posts = @user.posts.where(post_type: 'regular').order(created_at: :desc).page limit
    elsif params[:type].present? and params[:type] == 'external'
      @posts = @user.posts.where(post_type: 'external').order(created_at: :desc).page limit
    else
      @posts = @user.posts.order(created_at: :desc).page limit
    end

  end

end
