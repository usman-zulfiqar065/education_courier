# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :validate_user_summary, only: %i[update]

    def update
      super
    end

    protected

    def validate_user_summary
      params[:user]['user_summary_attributes'].delete(:id)
      return unless validated_params

      params[:user].delete(:user_summary_attributes)
      resource.user_summary.destroy if resource.user_summary.present?
    end

    def validated_params
      params[:user]['user_summary_attributes'].values.all?(&:blank?)
    end
  end
end
