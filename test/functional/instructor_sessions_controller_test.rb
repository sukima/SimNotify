require 'test_helper'

class InstructorSessionsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should route(:get, "/login").to(:action => 'new')
  should route(:get, "/logout").to(:action => 'destroy')
  should route(:get, "/signup").to(:controller => 'instructors', :action => 'new')
  # This doesn't work:
  # should route(:get, "/instructor_sessions/new").to(:action => 'new')
end
