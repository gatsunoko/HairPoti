class StylistsController < ApplicationController

  include ImageUpload

  def edit
    @user = User.find current_user.id
  end

  def update
    @user = User.find params[:id]
    if @user.update(user_params)
      if params[:picture].present?
        picture_destroy(dir: ENV['PROFILE_PICTURE_DIR'], picture: @user.picture)
        @user.picture = picture_up(file: "picture", picture_id: @user.id, name: "profile", dir: ENV['PROFILE_PICTURE_DIR'])

        @user.save
      end
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :name, :profile, :picture, stylist_attributes: [:id, :destroy, :shop_name, :shop_address, :shop_phone_number])
    end
end
