class LikesController < ApplicationController

  before_action :authenticate_user!

  def likes
    @likes = Like.where('user_id = ?', current_user.id).order(created_at: :desc).includes(:picture).page(params[:page]).per(12)
  end

  def like
    if Like.where('user_id = ? AND picture_id = ?', current_user.id, params[:id]).count == 0
      like = Like.where('user_id = ? AND picture_id = ?', current_user.id, params[:id]).first
      Like.create(user_id: current_user.id, picture_id: params[:id])
    else
      like = Like.where('user_id = ? AND picture_id = ?', current_user.id, params[:id])
      like.destroy_all
    end
    @picture = Picture.find params[:id]
  end
end
