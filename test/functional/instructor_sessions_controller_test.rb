require 'test_helper'

class InstructorSessionsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    post :create, :instructor_session => { :username => "foo", :password => "badpassword" }
    assert_template 'new'
    assert_nil InstructorSession.find
  end
  
  def test_create_valid
    post :create, :instructor_session => { :username => "foo", :password => "secret" }
    assert_redirected_to root_url
    assert_equal instructors(:foo), InstructorSession.find.instructor
  end
end
