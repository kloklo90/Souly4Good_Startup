class RegistrationsController < Devise::RegistrationsController

  before_action :load_posts, :only => [:edit, :update]

  protected

  def load_posts
    limit = params[:page] || 1
    if params[:type].present? and params[:type] == 'challenge'
      @posts = current_user.posts.where(post_type: 'challenge').order(created_at: :desc).page limit
    elsif params[:type].present? and params[:type] == 'regular'
      @posts = current_user.posts.where(post_type: 'regular').order(created_at: :desc).page limit
    elsif params[:type].present? and params[:type] == 'external'
      @posts = current_user.posts.where(post_type: 'external').order(created_at: :desc).page limit
    else
      @posts = current_user.posts.order(created_at: :desc).page limit
    end
  end

end