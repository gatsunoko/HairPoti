class UsersController < ApplicationController
  before_action :is_admin, only: [:index]
  before_action :set_user, only: [:show, :password_edit, :password_update]
  before_action :not_omniauthable, only: [:password_edit, :password_update]
  def index
    @users = User.all.page(params[:page]).per(20)
  end

  def show
    if @user.stylist?
      @pictures = Picture.where(user_id: params[:id]).includes(:picture_details).order(id: :desc).page(params[:page]).per(24)
    end
  end

  def password_edit
  end

  def password_update
    if @user.update(user_params)
      sign_in(@user, bypass: true)
      redirect_to user_path(@user)
    else
      render 'password_edit'
    end
  end

  private
    def set_user
      @user = User.find params[:id]
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def not_omniauthable
      if @user.provider.present?
        redirect_to root_path and return
      end
    end
end
