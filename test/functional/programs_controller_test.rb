require 'test_helper'

class ProgramsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :programs

  should_require_logged_in_access_for_resources

  # User :instructor {{{1
  logged_in_as :instructor do
    should_require_admin_access_for_resources :except => [ :index, :show ]

    # :index {{{2
    context "GET :index" do
      setup do
        get :index
      end
      should assign_to(:programs)
      should respond_with :success
      should render_template :index
    end

    # :show {{{2
    context "GET :show" do
      setup do
        @f = Factory(:program)
        get :show, :id => @f.id
      end
      should assign_to(:program)
      should respond_with :success
      should render_template :show
    end
  end

  # User :admin {{{1
  logged_in_as :admin do
    # :index {{{2
    context "GET :index" do
      setup do
        get :index
      end
      should assign_to(:programs)
      should respond_with :success
      should render_template :index
    end

    # :show {{{2
    context "GET :show" do
      setup do
        @f = Factory(:program)
        get :show, :id => @f.id
      end
      should assign_to(:program)
      should respond_with :success
      should render_template :show
    end

    # :new {{{2
    context "GET :new" do
      setup do
        get :new
      end
      should assign_to(:program)
      should respond_with :success
      should render_template :new
    end

    # :create {{{2
    context "POST :create" do
      setup do
        @f = Factory.build(:program)
        @old_count = Program.count
        post :create, :program => @f.attributes
        @program = Program.last
      end
      should "increase count by 1" do
        assert Program.count - @old_count == 1
      end
      should "set created_by in program model" do
        assert_not_nil @program.created_by, "Program model has nil for created_by"
      end
      should redirect_to(":show") { program_path(@program) }
    end

    # :edit {{{2
    context "GET :edit" do
      setup do
        @f = Factory(:program)
        get :edit, :id => @f.id
      end
      should assign_to(:program)
      should respond_with :success
      should render_template :edit
    end

    # :update {{{2
    context "PUT :update" do
      setup do
        @f = Factory(:program)
        @f.benifit = "test_update_model_program_field_benifit"
        put :update, :id => @f.id, :program => @f.attributes
      end
      should redirect_to(":show") { program_path(@f) }
    end

    # :destroy {{{2
    context "GET :destroy" do
      setup do
        @f = Factory(:program)
        @old_count = Program.count
        delete :destroy, :id => @f.id
      end
      should "decrease count by 1" do
        assert Program.count - @old_count == -1
      end
      should redirect_to(":index") { programs_path }
    end
  end

  # }}}1
end

# vim:set sw=2 ts=2 sts=2 et fdm=marker:
