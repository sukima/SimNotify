require 'test_helper'

class ManikinsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :manikins

  should_require_logged_in

  logged_in_as :instructor do
    should_require_admin(:action => :index)
    should_require_admin(:action => :new)
    should_require_admin(:action => :edit, :params => { :id => 1 })
    should_require_admin(:action => :create, :method => :post)
    should_require_admin(:action => :update, :method => :post, :params => { :id => 1 })
    should_require_admin(:action => :destroy, :params => { :id => 1 })
  end

  logged_in_as :admin do
    context "GET :index" do
      setup do
        get :index
      end
      should respond_with :success
      should render_template 'index'
    end

    context "GET :show" do
      setup do
        @f = Factory.create(:manikin)
        get :show, :id => @f.id
      end
      should_respond_with :success
      should_render_template :show
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
        @f= Factory.build(:manikin)
        @old_count = Manikin.count
        post :create, :manikin => @f.attributes
      end
      should "increase count by 1" do
        assert Manikin.count - @old_count == 1
      end
      should_redirect_to(":show") { manikin_path(Manikin.last) }
    end

    context "GET :edit" do
      setup do
        @f = Factory.create(:manikin)
        get :edit, :id => @f.id
      end
      should_respond_with :success
      should_render_template :edit
    end

    context "PUT :update" do
      setup do
        @f = Factory.create(:manikin)
        @f.serial_number = "1111111111"
        put :update, :id => @f.id, :manikin => @f.attributes
      end
      should_redirect_to(":show") { manikin_path(Manikin.find(@f.id)) }
    end

    context "GET :destroy" do
      setup do
        @f = Factory.create(:manikin)
        @old_count = Manikin.count
        delete :destroy, :id => @f.id
      end
      should "decrease count by 1" do
        assert Manikin.count - @old_count == -1
      end
      should_redirect_to(":index") { manikins_path }
    end
  end
end
