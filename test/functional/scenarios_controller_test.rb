require 'test_helper'

class ScenariosControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Scenario.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Scenario.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Scenario.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to scenario_url(assigns(:scenario))
  end
  
  def test_edit
    get :edit, :id => Scenario.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Scenario.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Scenario.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Scenario.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Scenario.first
    assert_redirected_to scenario_url(assigns(:scenario))
  end
  
  def test_destroy
    scenario = Scenario.first
    delete :destroy, :id => scenario
    assert_redirected_to scenarios_url
    assert !Scenario.exists?(scenario.id)
  end
end
