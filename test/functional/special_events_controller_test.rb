require 'test_helper'

class SpecialEventsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :special_events

  should_require_login_for_resources

  logged_in_as :instructor do
    # Stub out SpecialEvent.find
    should_require_admin_for_resources :except => [:index, :show, :new, :create],
      :flash => :permission_denied,
      :factory => :special_event
  end

  logged_in_as :instructor do
    %w(nil_value all old).each do |mod|
      context "GET :index with :mod => #{mod}" do
        setup do
          get :index, :mod => mod
        end
        should assign_to(:listing_mod)
        should assign_to(:special_events)
        should respond_with :success
        should render_template :index
      end
    end

    context "GET :show" do
      setup do
        @f = Factory(:special_event)
        get :show, :id => @f.id
      end
      should assign_to(:special_event)
      should respond_with :success
      should render_template :show
    end

    context "GET :new" do
      setup do
        get :new
      end
      should assign_to(:special_event)
      should respond_with :success
      should render_template :new
    end

    context "POST :create" do
      setup do
        @f = Factory.build(:special_event)
        @old_count = SpecialEvent.count
        post :create, :special_event => @f.attributes
      end
      should "increase count by 1" do
        assert SpecialEvent.count - @old_count == 1
      end
      should redirect_to(":show") { special_event_path(SpecialEvent.last) }
    end
  end

  logged_in_as :admin do
    context "GET :edit" do
      setup do
        @f = Factory.create(:special_event)
        get :edit, :id => @f.id
      end
      should assign_to(:special_event)
      should respond_with :success
      should render_template :edit
    end

    context "PUT :update" do
      setup do
        @f = Factory.create(:special_event)
        @f.title = "test_update_model_special_event_field_title"
        put :update, :id => @f.id, :special_event => @f.attributes
      end
      should redirect_to(":show") { special_event_path(@f) }
    end

    context "DELETE :destroy" do
      setup do
        @f = Factory.create(:special_event)
        @old_count = SpecialEvent.count
        delete :destroy, :id => @f.id
      end
      should "decrease count by 1" do
        assert SpecialEvent.count - @old_count == -1
      end
      should redirect_to(":index") { special_events_path }
    end
  end
end
