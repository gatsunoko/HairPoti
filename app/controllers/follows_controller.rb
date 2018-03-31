class FollowsController < ApplicationController
  def follow
    if Follow.where('user_id = ? AND stylist_id = ?', current_user.id, params[:id]).count == 0
      Follow.create(user_id: current_user.id, stylist_id: params[:id])
    else
      follow = Follow.where('user_id = ? AND stylist_id = ?', current_user.id, params[:id])
      follow.destroy_all
    end
    @user = User.find params[:id]
  end
end
