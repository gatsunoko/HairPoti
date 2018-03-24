class UsersController < ApplicationController
  before_action :is_admin, only: [:index]

  def index
  end

  def show
    @user = User.find params[:id]
    if @user.stylist?
      @pictures = Picture.where(user_id: params[:id]).includes(:picture_details).order(id: :desc).page(params[:page]).per(24)
    end
  end
end
