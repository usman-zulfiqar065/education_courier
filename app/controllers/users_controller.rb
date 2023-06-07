class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[subscribe]
  def show; end

  def subscribe
    user = User.find_by(email: params[:email])
    if user.present?
      user.update(is_subscriber: true)
      respond_to do |format|
        flash.now[:notice] = 'Thankx for your subscription'
        format.turbo_stream { render turbo_stream: turbo_stream.prepend('body_tag', partial: 'shared/toast') }
      end
    else
      redirect_to new_user_registration_path, alert: 'You need to sign up before continuing.'
    end
  end
end
