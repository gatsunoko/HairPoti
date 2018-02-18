class StylistsController < ApplicationController

  def edit
    @user = User.find current_user.id
  end

  def update
    @user = User.find params[:id]
    if @user.update(user_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :name, :profile, stylist_attributes: [:id, :destroy, :shop_name, :shop_address, :shop_phone_number])
    end
end
