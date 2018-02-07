class HomesController < ApplicationController
  def index
    @rankings = Picture.all.order(rating: :desc).limit(5).offset(0)
    @win_counts = Picture.all.order(win: :desc).limit(5).offset(0)
    if user_signed_in?
      @user_rankings = UserPicture.where(user_id: current_user.id).order(rating: :desc).limit(5).offset(0)
      @user_histories = UserPicture.where(user_id: current_user.id).where('win > ?', 0).order(voting_at: :desc).limit(5).offset(0)
    end
  end

  def after_signup
  end
end
