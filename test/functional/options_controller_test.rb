require 'test_helper'

class OptionsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :options, :only => [:index, :update]

  #should_require_logged_in :except
  #should_require_admin :except

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
    should redirect_to(":index") { option_path(@f) }
  end
end
