class UsersController < ApplicationController
  before_action :authenticate_user!


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
