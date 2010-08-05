class ApplicationMailer < ActionMailer::Base

  def welcome_email(instructor)
    recipients  instructor.email
    from        APP_CONFIG['system_email_address']
    subject     "Welcome to SimNotify;. Thank you for registering."
    sent_on     Time.now
    body        {:instructor => instructor}
  end
end
