require 'test_helper'

class OptionsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  except_routes = [:show, :edit, :new, :create, :destroy]

  should_map_resources :options, :except => except_routes

  should_require_logged_in :except => except_routes

  logged_in_as :instructor do
    should_require_admin :except => except_routes
  end

  logged_in_as :admin do
    context "GET :index" do
      setup do
        get :index
      end
      should assign_to(:options)
      should respond_with :success
      should render_template :index
    end

    context "PUT :update" do
      setup do
        @f = Factory(:option)
        @f.value = "test_update_model_option_field_value"
        put :update, :id => @f.id, :option => @f.attributes
      end
      should redirect_to(":index") { options_path }
    end
  end
end
