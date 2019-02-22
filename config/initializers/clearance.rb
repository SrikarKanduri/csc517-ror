Clearance.configure do |config|
  config.mailer_sender = "reply@example.com"
  config.rotate_csrf_on_sign_in = true
  # recommended that you disable Clearance routes and take full control over routing and URL design
  config.routes = false
end
