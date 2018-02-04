class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def is_admin
    return current_user.admin
  end
end
