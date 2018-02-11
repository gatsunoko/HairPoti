class HomesController < ApplicationController
  def index
    @rankings = Picture.all.order(rating: :desc).limit(5).offset(0)
    @midiamu_ranking = Picture.where('length = ?', 'ミディアム').order(rating: :desc).limit(5).offset(0)
    @long_ranking = Picture.where('length = ? OR length = ?', 'ロング', 'セミロング').order(rating: :desc).limit(5).offset(0)
    if user_signed_in?
      @user_histories = UserPicture.where(user_id: current_user.id).where('win > ?', 0).order(voting_at: :desc).limit(5).offset(0)
    end
  end

  def after_signup
  end
end
