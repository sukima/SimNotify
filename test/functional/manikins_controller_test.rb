require 'test_helper'

class ManikinsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Manikin.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Manikin.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Manikin.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to manikin_url(assigns(:manikin))
  end
  
  def test_edit
    get :edit, :id => Manikin.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Manikin.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Manikin.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Manikin.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Manikin.first
    assert_redirected_to manikin_url(assigns(:manikin))
  end
  
  def test_destroy
    manikin = Manikin.first
    delete :destroy, :id => manikin
    assert_redirected_to manikins_url
    assert !Manikin.exists?(manikin.id)
  end
end
