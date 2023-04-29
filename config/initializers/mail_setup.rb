ActionMailer::Base.smtp_settings = {
  user_name:      Rails.application.credentials.sendmail_email,
  password:       Rails.application.credentials.sendmail_password,
  domain:         Rails.application.credentials.mail_host,
  address:       'smtp.gmail.com',
  port:          '587',
  authentication: :plain,
  enable_starttls_auto: true
}
