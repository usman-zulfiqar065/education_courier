# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def new
      @user = User.new
      @user.build_user_summary
      subscriber_user if params[:email].present? && params[:role] == 'subscriber'
      @user.role = params[:role] if params[:role].present?
    end

    protected

    def subscriber_user
      user = User.find_by(email: params[:email])
      if user.present?
        handle_subscriber_creation_success(user)
      else
        handle_failed_subscriber_creation
      end
    end

    def handle_subscriber_creation_success(user)
      flash[:notice] = 'Thankx for your subscription'
      user.update(role: 'subscriber') if user.member?
      redirect_to root_path
    end

    def handle_failed_subscriber_creation
      flash.now[:alert] = 'You need to sign up before continuing.'
      @user.email = params[:email]
      @user.role = params[:role]
    end
  end
end
