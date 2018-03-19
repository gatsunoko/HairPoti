class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  include ImageUpload

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    old_role = resource.role
    ActiveRecord::Base.transaction do
      super
      @user = User.find resource.id
      picture_destroy(dir: ENV['PROFILE_PICTURE_DIR'], picture: @user.picture)
      @user.picture = picture_up(file: "picture", picture_id: @user.id, name: "profile", dir: ENV['PROFILE_PICTURE_DIR'])
      @user.save
      #ユーザータイプをユーザーからスタイリストに変更したら、スタイリスト用の子テーブルを追加
      Stylist.create(user_id: resource.id) if old_role == 'user' && resource.role == 'stylist'
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  protected
    def after_inactive_sign_up_path_for(resource)
      homes_after_signup_path
    end
    
    #パスワード変更画面以外ではパスワード無しでもユーザー情報が更新できるようにする
    def update_resource(resource, params)
      if params.has_key?('current_password') #パスワード変更画面かどうか
        resource.update_with_password(params)
      else
        resource.update_without_password(params)
      end
    end
end
