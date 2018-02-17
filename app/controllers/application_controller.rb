class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def is_admin
    unless current_user.admin
      redirect_to root_path and return
    end
  end

  protected
    def configure_permitted_parameters
      added_attrs = [:name, :profile, :shop_name, :shop_address, :shop_phone_number]

      devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
      devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
    end
end
