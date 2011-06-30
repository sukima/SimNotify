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
  end

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
      should assign_to(:tech)
      should assign_to(:date_range)
      should assign_to(:time_format)
      should render_template :agenda
    end

    context "GET :save_preferences" do
      context "with bad data" do
        setup do
          get :save_preferences, { :bad_data => "bad_value" }
        end
        should respond_with :not_acceptable
        should respond_with_content_type(/plain/)
      end
      context "with good data" do
        setup do
          get :save_preferences, {
            :facilities => [ "/test_url/?facility=A", "/test/?facility=X&foo", "bogus_value", "23", "special" ]
          }
        end
        should respond_with :success
        should respond_with_content_type(/plain/)
        should "assign session[:calendar_facilities_pref] as an array with count of 5" do
          assert @request.session[:calendar_facilities_pref].kind_of? Array
          assert_equal 5, @request.session[:calendar_facilities_pref].count
        end
        should "have session data save 'A' at index 0" do
          assert_equal "A", @request.session[:calendar_facilities_pref][0]
        end
        should "have session data save 'X' at index 1" do
          assert_equal "X", @request.session[:calendar_facilities_pref][1]
        end
        should "have session data save nil at index 2" do
          assert_nil @request.session[:calendar_facilities_pref][2]
        end
        should "have session data save '23' at index 3" do
          assert_equal "23", @request.session[:calendar_facilities_pref][3]
        end
        should "have session data save 'special' at index 4" do
          assert_equal "special", @request.session[:calendar_facilities_pref][4]
        end
      end
    end
  end

  private
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
