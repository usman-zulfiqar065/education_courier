class ApplicationMailer < ActionMailer::Base
  if Rails.env.production?
    default from: 'Education Courier <education.courier.team@gmail.com>'
  else
    default from: 'Education Courier Testing <education.courier.team@gmail.com>'
  end
  layout 'mailer'

  def admin_emails
    ENV['EC_ADMIN_EMAILS'].try(:split) || ['education.courier.team@gmail.com']
  end
end
