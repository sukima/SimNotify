require 'test_helper'

class CalendarControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should route(:get, "/calendar").to(:action => :index)
  should route(:get, "/calendar/events").to(:action => :events)

  should_require_logged_in
  should_require_logged_in :action => :events

  context "when logged in" do
    setup do
      InstructorSession.create(Factory(:instructor))
    end

    context "get :index" do
      setup do
        get :index
      end
      should respond_with :success
      should render_template :index
    end

    context "get :event" do
      context "without params" do
        setup do
          get :events
        end
        should respond_with :not_acceptable
      end

      context "with params" do
        setup do
          assert @event = Factory(:special_event)
          @start = @event.start_time - 5.days
          @end = @event.end_time + 5.days
          get :events, :start => @start, :end => @end
          begin
            @json = ActiveSupport::JSON.decode(@response.body)
          rescue
            @json = nil
          end
        end
        should respond_with :success
        should assign_to(:special_events).with(@event)
        should respond_with_content_type(/json/)
        context "json object" do
          should "be valid" do
            assert_not_nil @json, "possible exception thrown in setup (response: #{@response.body})"
          end
          should "have a title" do
            assert_not_nil @json[0]['title']
          end
          should "have a start and end time" do
            assert_not_nil @json[0]['start']
            assert_not_nil @json[0]['end']
          end
          should "have className == special-event" do
            assert_match "special-event", @json[0]['className']
          end
          should "have a allDay field" do
            assert_not_nil @json[0]['allDay']
          end
        end
      end
    end
  end
end
