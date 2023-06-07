class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[subscribe]
  def show; end

  def subscribe
    user = User.find_by(email: params[:email])
    if user.present?
      user.update(is_subscriber: true)
      redirect_to root_path, notice: 'Thankx for your subscription'
    else
      redirect_to new_user_registration_path, alert: 'You need to sign up before continuing.'
    end
  end
end
