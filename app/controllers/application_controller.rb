class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def is_admin
    unless current_user.admin? && current_user.admin
      redirect_to root_path and return
    end
  end

  def is_stylist
    unless current_user.stylist?
      redirect_to root_path and return
    end
  end

  def is_user
    unless current_user.user?
      redirect_to root_path and return
    end
  end

  def prefecture_ending(prefecture)
    if prefecture == '東京'
      return prefecture+'都'
    elsif prefecture == '大阪' || prefecture == '京都'
      return prefecture+'府'
    elsif prefecture == '北海道'
      return prefecture
    else
      return prefecture+'県'
    end
  end

  protected
    def configure_permitted_parameters
      added_attrs = [:name, :picture, :profile, :role]

      devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
      devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
    end
end
