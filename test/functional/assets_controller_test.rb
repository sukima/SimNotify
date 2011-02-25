require 'test_helper'

class AssetsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  # should_not route(:get, "/assets/1/edit").
                # to(:action => :edit, :id => 1)
  # should_not route(:put, "/assets/1").
                # to(:action => :update, :id => 1)
  # should_not route(:get, "/events/1/assets/2/edit").
                # to(:action => :edit, :event_id => 1, :id => 2)
  # should_not route(:get, "/events/1/assets/2").
                # to(:action => :show, :event_id => 1, :id => 2)
  # should_not route(:put, "/events/1/assets/2").
                # to(:action => :update, :event_id => 1, :id => 2)
  # should route(:get, "/assets/1/delete").
            # to(:action => :delete, :id => 1)

  should_map_resources :assets, :except => [:edit, :update]
  should_map_nested_resources :events, :assets, :except => [:edit, :update]

  should_require_login_for_resources :except => [:edit, :update]

  logged_in_as :instructor do
    context "GET :index" do
      setup do
        get :index
      end
      should assign_to(:assets)
      should respond_with :success
      should render_template :index
    end

    context "GET :show" do
      setup do
        @f = Factory(:asset)
        get :show, :id => @f.id
      end
      should assign_to(:asset)
      should respond_with :success
      should render_template :show
    end

    context "GET :new" do
      setup do
        get :new
      end
      should assign_to(:asset)
      should respond_with :success
      should render_template :new
    end

    context "POST :create" do
      setup do
        @f = Factory.build(:asset_attachment)
        @old_count = Asset.count
        put :create, :asset => @f.attributes, :multipart => true
      end
      should "increase count by 1" do
        assert Asset.count - @old_count == 1
      end
      should redirect_to(":show") { asset_path(Asset.last) }
    end

    context "GET :destroy" do
      setup do
        @f = Factory(:asset)
        @old_count = Asset.count
        delete :destroy, :id => @f.id
      end
      should "decrease count by 1" do
        assert Asset.count - @old_count == -1
      end
      should redirect_to(":index") { assets_path }
    end
  end
end
