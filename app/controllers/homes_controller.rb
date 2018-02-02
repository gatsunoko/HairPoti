class HomesController < ApplicationController
  def index
    @pictures = Picture.all.order(rating: :desc).limit(5).offset(0)
    if user_signed_in?
      @user_pictures = UserPicture.where(user_id: current_user.id).order(rating: :desc).limit(5).offset(0)
    end
  end
end
