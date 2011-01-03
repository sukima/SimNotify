require 'test_helper'

class LocationSuggestionsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :location_suggestions

  context "get :index" do
    should_require_logged_in :action => :index
    logged_in_as :instructor do
      context "with json format" do
        setup do
          get :index, { }, :format => :json
        end
        should respond_with :success
        should respond_with_content_type(/json/)
        should_have_json_element('location')
      end
    end
  end
  # def test_index
  #   get :index
  #   assert_template 'index'
  # end

  # def test_show
  #   get :show, :id => LocationSuggestion.first
  #   assert_template 'show'
  # end

  # def test_new
  #   get :new
  #   assert_template 'new'
  # end

  # def test_create_invalid
  #   LocationSuggestion.any_instance.stubs(:valid?).returns(false)
  #   post :create
  #   assert_template 'new'
  # end

  # def test_create_valid
  #   LocationSuggestion.any_instance.stubs(:valid?).returns(true)
  #   post :create
  #   assert_redirected_to location_suggestion_url(assigns(:location_suggestion))
  # end

  # def test_edit
  #   get :edit, :id => LocationSuggestion.first
  #   assert_template 'edit'
  # end

  # def test_update_invalid
  #   LocationSuggestion.any_instance.stubs(:valid?).returns(false)
  #   put :update, :id => LocationSuggestion.first
  #   assert_template 'edit'
  # end

  # def test_update_valid
  #   LocationSuggestion.any_instance.stubs(:valid?).returns(true)
  #   put :update, :id => LocationSuggestion.first
  #   assert_redirected_to location_suggestion_url(assigns(:location_suggestion))
  # end

  # def test_destroy
  #   location_suggestion = LocationSuggestion.first
  #   delete :destroy, :id => location_suggestion
  #   assert_redirected_to location_suggestions_url
  #   assert !LocationSuggestion.exists?(location_suggestion.id)
  # end
end
