require 'test_helper'

class ProgramSubmissionsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :program_submissions, :except => [ :edit, :update ]

  should_require_logged_in_access_for_resources :except => [ :new, :create, :edit, :update ]

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
      ApplicationMailer.stubs(:new_program_submission_email)
      @f = Factory.build(:program_submission)
      @old_count = ProgramSubmission.count
      post :create, :program_submission => @f.attributes
    end
    should "increase count by 1" do
      assert ProgramSubmission.count - @old_count == 1
    end
    should respond_with :success
    should render_template :thankyou
  end

  logged_in_as :instructor do
    should_require_admin_access_for_resources :except => [ :new, :create, :edit, :update ]
  end

  logged_in_as :admin do
    context "GET :index" do
      setup do
        get :index
      end
      should assign_to(:program_submissions)
      should respond_with :success
      should render_template :index
    end

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
        ApplicationMailer.stubs(:new_program_submission_email)
        @f = Factory.build(:program_submission)
        @old_count = ProgramSubmission.count
        post :create, :program_submission => @f.attributes
      end
      should "increase count by 1" do
        assert ProgramSubmission.count - @old_count == 1
      end
      should redirect_to(":show") { program_submission_path(ProgramSubmission.last) }
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
