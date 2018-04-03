class FollowsController < ApplicationController
  def followers
    @followers = Follow.where(stylist_id: params[:id]).includes(:user).order(id: :desc).page(params[:page]).per(24)
  end

  def follows
    @followers = Follow.where(user_id: params[:id]).includes(:user).order(id: :desc).page(params[:page]).per(24)
  end

  def follow
    if current_user.id.to_i != params[:id].to_i
      if Follow.where('user_id = ? AND stylist_id = ?', current_user.id, params[:id]).count == 0
        Follow.create(user_id: current_user.id, stylist_id: params[:id])
      end
      @user = User.find params[:id]
    else
      redirect_to root_path
    end
  end

  def stop_follow
    if current_user.id.to_i != params[:id].to_i
      unless Follow.where('user_id = ? AND stylist_id = ?', current_user.id, params[:id]).count == 0
        follow = Follow.where('user_id = ? AND stylist_id = ?', current_user.id, params[:id])
        follow.destroy_all
      end
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path
    end
  end
end
