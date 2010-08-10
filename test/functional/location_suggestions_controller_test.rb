require 'test_helper'

class LocationSuggestionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => LocationSuggestion.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    LocationSuggestion.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    LocationSuggestion.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to location_suggestion_url(assigns(:location_suggestion))
  end

  def test_edit
    get :edit, :id => LocationSuggestion.first
    assert_template 'edit'
  end

  def test_update_invalid
    LocationSuggestion.any_instance.stubs(:valid?).returns(false)
    put :update, :id => LocationSuggestion.first
    assert_template 'edit'
  end

  def test_update_valid
    LocationSuggestion.any_instance.stubs(:valid?).returns(true)
    put :update, :id => LocationSuggestion.first
    assert_redirected_to location_suggestion_url(assigns(:location_suggestion))
  end

  def test_destroy
    location_suggestion = LocationSuggestion.first
    delete :destroy, :id => location_suggestion
    assert_redirected_to location_suggestions_url
    assert !LocationSuggestion.exists?(location_suggestion.id)
  end
end
