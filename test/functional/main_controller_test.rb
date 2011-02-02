require 'test_helper'

class MainControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should route(:get, "/help").to(:action => :help)
  should route(:get, "/main/autocomplete_map").to(:action => :autocomplete_map)

  should_require_logged_in
  should_require_logged_in :action => :help

  context "get :autocomplete_map" do
    setup do
      get :autocomplete_map
    end
    should respond_with :success
    should respond_with_content_type(/json/)
    should_have_json_element('instructor_session_email')
    should "not contain anything more for anonymous user" do
      assert_nothing_raised do
        @json = ActiveSupport::JSON.decode(@response.body)
      end
      assert @json.count == 1
    end
  end

  logged_in_as :instructor do
    context "get :autocomplete_map" do
      setup do
        get :autocomplete_map
      end
      should respond_with :success
      should respond_with_content_type(/json/)
      should_have_json_element('instructor_session_email')
      should_have_json_element('event_location')
      should_have_json_element('event_instructors')
    end

    context "get :index" do
      setup do
        get :index
      end
      should assign_to(:events_in_queue)
      should assign_to(:events_submitted)
      should assign_to(:events_approved)
      should respond_with :success
      should render_template :index
    end

    context "get :help" do
      setup do
        get :help
      end
      should respond_with :success
      should assign_to(:is_help).with(true)
      should render_template :help
    end
  end
end
