require 'test_helper'

class CalendarControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should route(:get, "/calendar").to(:action => :index)
  should route(:get, "/calendar/events").to(:action => :events)

  should_require_logged_in
  should_require_logged_in :action => :events

#  logged_in_as(:instructor) do
#    setup { @event = Factory(:special_event) }
#    context "get index" do
#      setup { get :index }
#      should render_template :index
#    end

#    context "get events without params" do
#      setup { get :events }
#      should respond_with :not_acceptable
#    end

#    context "get events any format" do
#      setup { get :events, { :start => 0, :end => 1 } }
#      should respond_with :not_acceptable
#    end

#    context "get events json format" do
#      setup { get :events, { :format => :json, :start => 0, :end => 1 } }
#      should respond_with :success
#    end
#  end
end
