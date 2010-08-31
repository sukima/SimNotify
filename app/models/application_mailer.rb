class ApplicationMailer < ActionMailer::Base
  def welcome_email(instructor)
    recipients  instructor.email
    from        APP_CONFIG[:system_email_address]
    subject     "Welcome to #{APP_CONFIG[:application_name]}. Thank you for registering."
    sent_on     Time.now
    body        :instructor => instructor
  end

  def submitted_email(event)
    recipients  Instructor.notify_emails()
    cc          event.instructor.email
    reply_to    event.instructor.email
    from        APP_CONFIG[:system_email_address]
    subject     "[#{APP_CONFIG[:application_name]}] New session requested: #{event.title}"
    sent_on     Time.now
    body        :event => event
  end
end
