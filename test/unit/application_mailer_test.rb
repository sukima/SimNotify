require 'test_helper'

class ApplicationMailerTest < ActionMailer::TestCase
  context "ApplicationMailer" do
    should "have a welcome_email method" do
      assert_respond_to ApplicationMailer, :deliver_welcome_email
    end
    should "have a submitted_email method" do
      assert_respond_to ApplicationMailer, :deliver_submitted_email
    end
    should "have a revoked_email method" do
      assert_respond_to ApplicationMailer, :deliver_revoked_email
    end
    should "have a approved_email method" do
      assert_respond_to ApplicationMailer, :deliver_approved_email
    end
  end
end
