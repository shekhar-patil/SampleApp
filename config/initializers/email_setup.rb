

Rails.application.config.action_mailer.raise_delivery_errors = true
Rails.application.config.action_mailer.perform_deliveries = true
Rails.application.config.action_mailer.delivery_method = :smtp


if Rails.env.development?
  host = ENV['DEVELOPMENT_HOST']
elsif Rails.env.production?
  host = 'http://sampleapptutorial777.herokuapp.com/'
end

Rails.application.config.action_mailer.default_url_options = { host: host }
Rails.application.config.action_mailer.smtp_settings = {
  address: "smtp.gmail.com",
  port: 587,
  user_name: ENV['GMAIL_USERNAME'],
  password: ENV['GMAIL_PASSWORD'],
  authentication: :plain,
  enable_starttls_auto: true
}
