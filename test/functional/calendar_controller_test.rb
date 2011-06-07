require 'test_helper'

class CalendarControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should route(:get, "/calendar").to(:action => :index)
  should route(:get, "/calendar/events").to(:action => :events)
  should route(:get, "/calendar/agenda").to(:action => :agenda)

  should_require_logged_in
  should_require_logged_in :action => :events
  should_require_logged_in :action => :agenda

  logged_in_as :instructor do
    context "get :index" do
      setup do
        get :index
      end
      should respond_with :success
      should render_template :index
    end

    context "get :agenda" do
      should_require_admin :action => :agenda
    end

    context "get :events" do
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
          get :events, :start => @start.to_i, :end => @end.to_i
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

  logged_in_as :admin do
    context "get :agenda" do
      setup do
        get :agenda
      end
      should respond_with :success
      should assign_to(:number_of_weeks).with(3) # default
      should assign_to(:weeks)
      should assign_to(:date_range)
      should assign_to(:time_format)
      should render_template :agenda
    end
  end
end
