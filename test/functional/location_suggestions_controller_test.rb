require 'test_helper'

class LocationSuggestionsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :location_suggestions

  should_require_logged_in

  logged_in_as :instructor do
    should_require_admin(:action => :index)
    should_require_admin(:action => :new)
    should_require_admin(:action => :edit, :params => { :id => 1 })
    should_require_admin(:action => :create, :method => :post)
    should_require_admin(:action => :update, :method => :post, :params => { :id => 1 })
    should_require_admin(:action => :destroy, :params => { :id => 1 })
    context "get :index with json format" do
      setup do
        get :index, :format => "json"
      end
      should respond_with :success
      should respond_with_content_type(/json/)
      should "return a json array" do
        assert_match /\[.*\]/, @response.body
      end
    end
  end

  logged_in_as :admin do
    context "get :index" do
      setup do
        get :index
      end
      should respond_with :success
      should render_template 'index'
    end

    context "GET :new" do
      setup do
        get :new
      end
      should_respond_with :success
      should_render_template :new
    end

    context "POST :create" do
      setup do
        @old_count = LocationSuggestion.count
        post :create, :location_suggestion => { :location => "foobar" }
      end
      should "increase count by 1" do
        assert LocationSuggestion.count - @old_count == 1
      end
      should_redirect_to(":show") { location_suggestion_path(LocationSuggestion.last) }
    end
    
    context "GET :show" do
      setup do
        # id only used to route properly
        get :show, :id => 1
      end
      # no ID needed as this is just a redirect
      should redirect_to(":index") { location_suggestions_path }
    end

    context "PUT :update" do
      setup do
        @loc = Factory.create(:location_suggestion)
        put :update, :id => @loc.id, :location_suggestion => { :location => "barfoo" }
      end
      should_redirect_to(":show") { location_suggestion_path(LocationSuggestion.find(@loc.id)) }
    end

    context "GET :destroy" do
      setup do
        @loc = Factory.create(:location_suggestion)
        @old_count = LocationSuggestion.count
        delete :destroy, :id => @loc.id
      end
      should "decrease count by 1" do
        assert LocationSuggestion.count - @old_count == -1
      end
      should_redirect_to(":index") { location_suggestions_path }
    end
  end # logged_in_as :admin
end
