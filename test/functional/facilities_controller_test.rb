require 'test_helper'

class FacilitiesControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :facilities, :except => [:show]

  should_require_login_for_resources :except => [:show]

  logged_in_as :instructor do
    should_require_admin_for_resources :except => [:show],
      :flash => :permission_denied, :factory => :event
  end


  logged_in_as :admin do
    context "GET :index" do
      setup do
        get :index
      end
      should assign_to(:facilities)
      should respond_with :success
      should render_template :index
    end

    # Facilities currently only have one attribute.
    # Seems silly to have a show action.
    # context "GET :show" do
      # setup do
        # @f = Factory(:facility)
        # get :show, :id => @f.id
      # end
      # should assign_to(:facility)
      # should respond_with :success
      # should render_template :show
    # end

    context "GET :new" do
      setup do
        get :new
      end
      should assign_to(:facility)
      should respond_with :success
      should render_template :new
    end

    context "POST :create" do
      setup do
        @f = Factory.build(:facility)
        @old_count = Facility.count
        post :create, :facility => @f.attributes
      end
      should "increase count by 1" do
        assert Facility.count - @old_count == 1
      end
      should redirect_to(":index") { facilities_path }
    end

    context "GET :edit" do
      setup do
        @f = Factory(:facility)
        get :edit, :id => @f.id
      end
      should assign_to(:facility)
      should respond_with :success
      should render_template :edit
    end

    context "PUT :update" do
      setup do
        @f = Factory(:facility)
        @f.name = "test_update_model_facility_field_name"
        put :update, :id => @f.id, :facility => @f.attributes
      end
      should redirect_to(":index") { facilities_path }
    end

    context "GET :destroy" do
      setup do
        @f = Factory(:facility)
        @old_count = Facility.count
        delete :destroy, :id => @f.id
      end
      should "decrease count by 1" do
        assert Facility.count - @old_count == -1
      end
      should redirect_to(":index") { facilities_path }
    end
  end
end
