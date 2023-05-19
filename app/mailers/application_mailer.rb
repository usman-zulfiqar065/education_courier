class ApplicationMailer < ActionMailer::Base
  if Rails.env.production?
    default from: 'Education Courier <usman.zulfiqar065@gmail.com>'
  else
    default from: 'Education Courier Testing <usman.zulfiqar065@gmail.com>'
  end
  layout 'mailer'

  def admin_emails
    ENV['EC_ADMIN_EMAILS'].try(:split) || ['usman.zulfiqar065@gmail.com']
  end
end
