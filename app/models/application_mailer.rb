class ApplicationMailer < ActionMailer::Base
  add_template_helper(LayoutHelper)

  def welcome_email(instructor)
    recipients  instructor.email
    from        APP_CONFIG[:system_email_address]
    subject     "Welcome to #{APP_CONFIG[:application_name]}. Thank you for registering."
    sent_on     Time.now
    body        :instructor => instructor
  end

  def submitted_email(event)
    recipients  ApplicationMailer.recipients_from_options
    cc          event.instructor.email
    reply_to    event.instructor.email
    from        APP_CONFIG[:system_email_address]
    subject     "[#{APP_CONFIG[:application_name]}] New session requested: #{event.title}"
    sent_on     Time.now
    body        :event => event
  end

  def revoked_email(event)
    recipients  ApplicationMailer.recipients_from_options
    cc          event.instructor.email
    reply_to    event.instructor.email
    from        APP_CONFIG[:system_email_address]
    subject     "[#{APP_CONFIG[:application_name]}] Session revoked: #{event.title}"
    sent_on     Time.now
    body        :event => event
  end

  def approved_email(event)
    recipients  event.instructor.email
    cc          event.instructors.map(&:email)
    from        APP_CONFIG[:system_email_address]
    subject     "[#{APP_CONFIG[:application_name]}] Session approved: #{event.title}"
    sent_on     Time.now
    body        :event => event
  end

  def notify_email(event)
    recipients  event.instructor.email
    cc          event.instructors.map(&:email)
    from        APP_CONFIG[:system_email_address]
    subject     "[#{APP_CONFIG[:application_name]}] Upcomming Session: #{event.title}"
    sent_on     Time.now
    body        :event => event
  end

  def new_program_submission_email(program_submission)
    recipients  ApplicationMailer.recipients_from_options
    cc          program_submission.email
    reply_to    program_submission.email
    from        APP_CONFIG[:system_email_address]
    subject     "[#{APP_CONFIG[:application_name]}] New program application submitted from: #{program_submission.name}"
    sent_on     Time.now
    body        :program_submission => program_submission
  end

  # Find the emails that should be sent out to. The typical way to handle this
  # is to search the Option model for the entry +system_email_recipients+ which
  # is an array of ids that associate to the Instructor model.
  #
  # ==== Attributes
  #
  # * +instructor_ids+ - an array if Instructor ids. Use this to override the
  #   Option model lookup.
  #
  # ==== Known issues
  #
  # It is important to know that Instructors are referenced in the Option model
  # manually. This means there is no ActiveRecord magic involved. If the ids
  # change or the Instructors removed from the database the data stored in the
  # Option model *will become corrupt*!
  def self.recipients_from_options(instructor_ids=nil)
    if instructor_ids.nil?
      o = Option.find_by_name('system_email_recipients')
      instructor_ids = o.value unless o.nil?
    end
    return APP_CONFIG[:system_email_address] if instructor_ids.nil? || instructor_ids.empty?
    return Instructor.find(instructor_ids, :select => 'email').map(&:email)
  end

  # Find all events upcomming in the next N-days and send out a notification.
  #
  # ==== Attributes
  #
  # * +days+ - the number of days to look forward and find events.
  def self.send_upcoming_notifications(days=nil)
    if days.nil?
      o = Option.find_by_name('days_to_send_event_notifications')
      days = o.value
    end
    events = Event.find_upcomming_approved(days)
    events.each do |e|
      if e.notification_sent_on.nil?
        ApplicationMailer.deliver_notify_email(e)
        e.notification_sent_on = Time.now
        e.save
      end
    end
  end
end
