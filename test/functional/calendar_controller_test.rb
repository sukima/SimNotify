require 'test_helper'

class CalendarControllerTest < ActionController::TestCase
  def build_factory
      @event = Factory(:special_event)
  end
  setup :activate_authlogic

  should route(:get, "/calendar").to(:action => :index)
  should route(:get, "/calendar/events").to(:action => :events)

  should_require_logged_in
  should_require_logged_in :action => :events

  context "get index" do
    setup do
      build_factory
      get :index
    end
    should render_template :index
  end

  context "get events without params" do
    setup do
      build_factory
      get :events
    end
    should respond_with :not_acceptable
  end

  context "get events any format" do
    setup do
      build_factory
      get :events, { :start => 0, :end => 1 }
    end
    should respond_with :not_acceptable
  end

  context "get events json format" do
    setup do
      build_factory
      get :events, { :format => :json, :start => 0, :end => 1 }
    end
    should respond_with :success
  end
end
