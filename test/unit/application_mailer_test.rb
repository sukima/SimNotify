require 'test_helper'

class ApplicationMailerTest < ActionMailer::TestCase
  context "recipients_from_options()" do
    should "return default system email if none configured" do
      recipients = ApplicationMailer.recipients_from_options( [ ] ) 
      assert_equal APP_CONFIG[:system_email_address], recipients
    end
    should "return array with instructor email" do
      @instructor = Factory(:instructor)
      @emails = [ @instructor.id ]
      recipients = ApplicationMailer.recipients_from_options( @emails ) 
      assert recipients.kind_of? Array
      assert recipients.include? @instructor.email
    end
  end

  context "Notification emails" do
    context "for new instructors" do
      setup do
        @instructor = Factory(:instructor)
      end
      should "send email for deliver_welcome_email" do
        ApplicationMailer.deliver_welcome_email(@instructor)
        assert_emails 1
      end
    end
    context "for events" do
      setup do
        @event = Factory(:event)
      end
      should "send email for deliver_submitted_email" do
        ApplicationMailer.deliver_submitted_email(@event)
        assert_emails 1
      end
      should "send email for deliver_revoked_email" do
        ApplicationMailer.deliver_revoked_email(@event)
        assert_emails 1
      end
      should "send email for deliver_approved_email" do
        ApplicationMailer.deliver_approved_email(@event)
        assert_emails 1
      end
      should "send email for deliver_notify_email" do
        ApplicationMailer.deliver_notify_email(@event)
        assert_emails 1
      end
    end
    context "method send_upcoming_notifications" do
      setup do
        @event = Factory(:approved)
        ApplicationMailer.send_upcoming_notifications(5)
      end
      should "send email" do
        assert_emails 1
      end
    end
  end
end
