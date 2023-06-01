class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_current_location, unless: :devise_controller?
  add_flash_types :error

  protected

  def store_current_location
    store_location_for(:user, request.url) if params[:controller] != 'comments'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password role avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name email password role avatar])
  end

  def authenticate_admin_user!
    raise SecurityError unless current_user.admin?
  end

  rescue_from SecurityError do
    flash[:error] = 'You are not authorized for this action'
    redirect_to root_path
  end
end
