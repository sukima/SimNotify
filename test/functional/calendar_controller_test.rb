require 'test_helper'

class CalendarControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should route(:get, "/calendar").to(:action => :index)
  should route(:get, "/calendar/events").to(:action => :events)
  should route(:get, "/calendar/agenda").to(:action => :agenda)

  # Check for required login {{{1
  should_require_logged_in_access_for [:index, :agenda, :save_preferences]
  should_require_logged_in_access_for :tech_schedule, :tech_id => 1

  # Logged in as :instructor tests {{{1
  logged_in_as :instructor do

    should_require_admin_access_for [:agenda]
    # Needs admin if tech_id != current_instructor.id
    context "get :tech_schedule with id that is not self" do
      setup do
        @tech = Factory(:technician)
        get :tech_schedule, :tech_id => @tech.id
      end
      should_require_admin_access
    end

    context "get :index" do
      setup do
        get :index
      end
      should respond_with :success
      should render_template :index
    end

    context "get :events" do
      context "without params" do
        setup do
          get :events
        end
        should respond_with :not_acceptable
      end

      context "with special event," do
        setup do
          construct_params :special_event
          construct_json_object
        end
        should_pass_standard_calendar_tests
        context "the json object" do
          should "have a color" do
            assert_not_nil @json[0]['color']
          end
          should "have a allDay field" do
            assert_not_nil @json[0]['allDay']
          end
        end
      end

      context "with a normal event," do
        setup do
          construct_params :event
          construct_json_object
        end
        should_pass_standard_calendar_tests
        context "the json object" do
          should "show a busy title" do
            assert_match "Session Scheduled", @json[0]['title']
          end
          should "not have url" do
            assert_nil @json[0]['url']
          end
          should "have a color" do
            assert_not_nil @json[0]['color']
          end
        end
      end
    end

    context "GET :save_preferences" do
      context "with bad data" do
        setup do
          get :save_preferences, { :bad_data => "bad_value" }
        end
        should respond_with :not_acceptable
      end
      context "with good data" do
        setup do
          get :save_preferences, {
            :facilities => [
              "/test_url/?facility=A",
              "/test/?facility=2",
              "/test/?facility=5&foo",
              "bogus_value",
              "23",
              "special"
            ]
          }
        end
        should respond_with :success
        should "assign session[:calendar_facilities_pref] as an array with count of 6" do
          assert @request.session[:calendar_facilities_pref].kind_of? Array
          assert_equal 6, @request.session[:calendar_facilities_pref].count
        end
        should "have session data save nil at index 0" do
          assert_nil @request.session[:calendar_facilities_pref][0]
        end
        should "have session data save '2' at index 1" do
          assert_equal "2", @request.session[:calendar_facilities_pref][1]
        end
        should "have session data save '5' at index 2" do
          assert_equal "5", @request.session[:calendar_facilities_pref][2]
        end
        should "have session data save nil at index 3" do
          assert_nil @request.session[:calendar_facilities_pref][3]
        end
        should "have session data save '23' at index 4" do
          assert_equal "23", @request.session[:calendar_facilities_pref][4]
        end
        should "have session data save 'special' at index 5" do
          assert_equal "special", @request.session[:calendar_facilities_pref][5]
        end
      end
    end
  end

  # logged in as :technician test {{{1
  logged_in_as :technician do
    context "get :tech_schedule" do
      setup do
        get :tech_schedule, :tech_id => @current_instructor.id
      end
      should respond_with :success
    end
  end

  # logged in as :admin tests {{{1
  logged_in_as :admin do
    context "get :events" do
      context "with unsubmitted event," do
        setup do
          construct_params :event
          construct_json_object
        end
        should_pass_standard_calendar_tests
        context "json object" do
          should "have a color" do
            assert_not_nil @json[0]['color']
          end
        end
      end

      context "with approved event," do
        setup do
          construct_params :event_with_facility
          construct_json_object
        end
        should_pass_standard_calendar_tests
        context "the json object" do
          should "have color == #36c" do
            assert_match "#36c", @json[0]['color']
          end
        end
      end

      context "with facility param" do
        setup do
          assert @special = Factory(:special_event)
          construct_params :event_with_facility
          construct_json_object({ :facility => @event.facility.id })
        end
        should_pass_standard_calendar_tests
        should "not have special event included" do
          assert @json.length == 1
        end
      end

      context "with facility 'special' param" do
        setup do
          assert @special = Factory(:special_event)
          construct_params :event_with_facility
          construct_json_object({ :facility => "special" })
        end
        should_pass_standard_calendar_tests
        should "not have event included" do
          assert @json.length == 1
        end
      end

      context "with facility 'all' param" do
        setup do
          assert @special = Factory(:special_event)
          construct_params :event_with_facility
          construct_json_object({ :facility => "all" })
        end
        should_pass_standard_calendar_tests
        should "have special and event included" do
          assert @json.length == 2
        end
      end
    end

    context "get :tech_schedule" do
      setup do
        @tech = Factory(:technician)
        @event = Factory(:event, :technician => @tech)
      end
      context "without week_index" do
        setup do
          get :tech_schedule, { :tech_id => @tech.id }
        end
        should respond_with :success
        should assign_to(:week_index).with("0")
        should assign_to(:tech)
        should assign_to(:tech_id)
        should assign_to(:start_of_week)
        should assign_to(:end_of_week)
        should assign_to(:events)
        should render_template :tech_schedule
      end
      context "with week_index=>3" do
        setup do
          get :tech_schedule, { :tech_id => @tech.id, :week_index => 3 }
        end
        should respond_with :success
        should assign_to(:week_index).with("3")
        should assign_to(:tech)
        should assign_to(:tech_id)
        should assign_to(:start_of_week)
        should assign_to(:end_of_week)
        should assign_to(:events)
        should render_template :tech_schedule
      end
    end

    context "get :agenda" do
      setup do
        get :agenda, { :weeks => 3 }
      end
      should respond_with :success
      should assign_to(:number_of_weeks).with(3) # default
      should assign_to(:weeks)
      should assign_to(:date_range)
      should assign_to(:time_format)
      should render_template :agenda
    end

    context "get :agenda with tech" do
      setup do
        @event = Factory(:event)
        get :agenda, { :tech => 2 }
      end
      should respond_with :success
      should assign_to(:number_of_weeks)
      should assign_to(:weeks)
      should assign_to(:tech_id)
      should assign_to(:date_range)
      should assign_to(:time_format)
      should render_template :agenda
    end
  end

  private # {{{1
  def construct_params(event_type)
    assert @event = Factory(event_type)
    assert @start = @event.start_time - 5.days
    assert @end = @event.end_time + 5.days
  end

  def construct_json_object(params={})
    params.merge!({ :start => @start.to_i, :end => @end.to_i })
    get :events, params
    begin
      @json = ActiveSupport::JSON.decode(@response.body)
    rescue
      @json = nil
    end
    @json = [{}] if (@json.nil? || @json[0].nil?)
  end
end
# vim:set sw=2 ts=2 et fdm=marker:
