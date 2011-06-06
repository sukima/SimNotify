require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should "true" do
    assert true
  end
  should route(:get, "/notifications").to(:action => :index)
  should route(:get, "/notifications/send/1").to(:action => :send_notice, :event_id => 1)
  should route(:get, "/notifications/batch_send").to(:action => :batch_send)

  should_require_admin(:action => :index)
  should_require_admin(:action => :send_notice)
  should_require_admin(:action => :batch_send)

  logged_in_as :admin do
    context "" do
      setup do
        @event = Factory(:approved)
        ApplicationMailer.stubs(:send_upcoming_notifications)
        ApplicationMailer.stubs(:deliver_notify_email)
      end
      context "GET :index" do
        setup do
          get :index
        end
        should assign_to(:events)
        should respond_with :success
        should render_template :index
      end
      context "GET :send_notice" do
        setup do
          get :send_notice, :event_id => @event.id
        end
        should set_the_flash
        should redirect_to(":index") { notifications_path }
      end
      context "GET :batch_send" do
        setup do
          get :batch_send
        end
        should set_the_flash
        should redirect_to(":index") { notifications_path }
      end
    end
  end
end
