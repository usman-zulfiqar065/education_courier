class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :store_current_location, :unless => :devise_controller?
  add_flash_types :error

  protected

  def store_current_location
    store_location_for(:user, request.url) if params[:controller] != 'comments'
  end

  def authenticate_admin_user!
    raise SecurityError unless current_user.admin?
  end

  rescue_from SecurityError do
    flash[:error] = 'You are not authorized for this action'
    redirect_to root_path
  end
end
