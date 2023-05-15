class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :store_current_location, :unless => :devise_controller?
  add_flash_types :error

  protected

  def store_current_location
    store_location_for(:user, request.url) if params[:controller] != 'comments'
  end
end
