require 'test_helper'

class ProgramsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :programs

  logged_in_as :instructor do
    context "GET :index" do
      setup do
        get :index
      end
      should assign_to(:programs)
      should respond_with :success
      should render_template :index
    end

    context "GET :show" do
      setup do
        @f = Factory(:program)
        get :show, :id => @f.id
      end
      should assign_to(:program)
      should respond_with :success
      should render_template :show
    end

    context "GET :new" do
      setup do
        get :new
      end
      should_require_admin_access :redirect => :programs_path
    end

    # context "PUT :update" do
      # setup do
        # @f = Factory(:program)
        # @f.benifit = "test_update_model_program_field_benifit"
        # put :update, :id => @f.id, :program => @f.attributes
      # end
      # should_require_admin
    # end

    # context "GET :edit" do
      # setup do
        # @f = Factory(:program)
        # get :edit, :id => @f.id
      # end
      # should_require_admin
    # end

    # #testdestroy
  end
end
