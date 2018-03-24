class StylistsController < ApplicationController

  include ImageUpload
  include MunicipalityWhere

  def edit
    @user = User.find current_user.id
  end

  def update
    @user = User.find params[:id]
    old_address = @user.stylist.shop_address
    ActiveRecord::Base.transaction do
      if @user.update(user_params)
        #住所が変わっていたら登録している画像のprefecture_idとmunicipality_idも変更する
        if old_address != @user.stylist.shop_address
          @user.pictures.each do |picture|
            picture.prefecture_id = prefecture_where(@user.stylist.shop_address)
            prefecture = prefecture_ending(Prefecture.find(picture.prefecture_id).name) if picture.prefecture_id.present?
            picture.municipality_id = municipality_where(@user.stylist.shop_address, prefecture) if picture.prefecture_id.present?
            picture.save
          end
        end

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
  end

  private
    def user_params
      params.require(:user).permit(:email, :name, :profile, :picture, stylist_attributes: [:id, :destroy, :shop_name, :shop_address, :shop_phone_number])
    end
end