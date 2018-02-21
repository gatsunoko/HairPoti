class HomesController < ApplicationController
  def index
    @short_rankings = Picture.where('length = ? OR length = ?', 'ショート', 'ベリーショート').where(picture_present: true).order(rating: :desc).limit(5).offset(0)
    @midiamu_ranking = Picture.where('length = ?', 'ミディアム').where(picture_present: true).order(rating: :desc).limit(5).offset(0)
    @long_ranking = Picture.where('length = ? OR length = ?', 'ロング', 'セミロング').where(picture_present: true).order(rating: :desc).limit(5).offset(0)
    if user_signed_in?
      @user_histories = UserPicture.where(user_id: current_user.id).where('win > ?', 0).order(voting_at: :desc).limit(5).offset(0).includes(:picture)
    end

    if session[:area_default].present?
      @area_default = session[:area_default]
    else
      @area_default = '全国'
    end

    if session[:length_default].present?
      @length_default = session[:length_default]
    else
      @length_default = Array.new
    end
  end

  def after_signup
  end
end
