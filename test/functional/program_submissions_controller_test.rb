require 'test_helper'

class ProgramSubmissionsControllerTest < ActionController::TestCase
  # TODO: Test for logged in/admin status

  context "GET :new" do
    setup do
      get :new
    end
    should assign_to(:program_submission)
    should respond_with :success
    should render_template :new
  end

  context "POST :create" do
    setup do
      @f = Factory.build(:program_submission)
      @old_count = ProgramSubmission.count
      post :create, :program_submission => @f.attributes
    end
    should "increase count by 1" do
      assert ProgramSubmission.count - @old_count == 1
    end
    should redirect_to(":show") { program_submission_path(ProgramSubmission.last) }
  end

  loggedin_as :admin
    context "GET :index" do
      setup do
        get :index
      end
      should assign_to(:program_submissions)
      should respond_with :success
      should render_template :index
    end

    context "GET :show" do
      setup do
        @f = Factory(:program_submission)
        get :show, :id => @f.id
      end
      should assign_to(:program_submission)
      should respond_with :success
      should render_template :show
    end

    context "GET :destroy" do
      setup do
        @f = Factory(:program_submission)
        @old_count = ProgramSubmission.count
        delete :destroy, :id => @f.id
      end
      should "decrease count by 1" do
        assert ProgramSubmission.count - @old_count == -1
      end
      should redirect_to(":index") { program_submissions_path }
    end
  end
end
