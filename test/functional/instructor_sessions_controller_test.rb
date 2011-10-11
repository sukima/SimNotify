require 'test_helper'

class InstructorSessionsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should route(:get, "/login").to(:action => 'new')
  should route(:get, "/logout").to(:action => 'destroy')
end
