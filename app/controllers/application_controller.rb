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
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password is_subscriber])
    devise_parameter_sanitizer.permit(:account_update, keys: devise_account_update_params)
  end

  def authenticate_admin_user!
    raise SecurityError unless current_user.admin? || current_user.blogger?
  end

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  rescue_from SecurityError do
    flash[:error] = 'You are not authorized for this action'
    redirect_to root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url, error: exception.message
  end

  private

  def devise_account_update_params
    [:name, :email, :password, :avatar, :is_subscriber,
     { user_summary_attributes: %i[id title github twitter linked_in] }]
  end
end
