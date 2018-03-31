class FollowsController < ApplicationController
  def followers
    @followers = Follow.where(stylist_id: params[:id]).order(id: :desc).page(params[:page]).per(24)
  end

  def follows
    @followers = Follow.where(user_id: params[:id]).order(id: :desc).page(params[:page]).per(24)
  end

  def follow
    return if current_user.id == params[:id]
    if Follow.where('user_id = ? AND stylist_id = ?', current_user.id, params[:id]).count == 0
      Follow.create(user_id: current_user.id, stylist_id: params[:id])
    else
      follow = Follow.where('user_id = ? AND stylist_id = ?', current_user.id, params[:id])
      follow.destroy_all
    end
    @user = User.find params[:id]
  end
end
