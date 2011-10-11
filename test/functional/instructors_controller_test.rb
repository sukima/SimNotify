require 'test_helper'

class InstructorsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should route(:get, "/instructors/emails").to(:action => :emails)
  should route(:get, "/signup").to(:action => 'new')
  # This doesn't work:
  # should route(:get, "/instructor_sessions/new").to(:action => 'new')
  should_map_resources :instructors, :except => :new

  should_require_logged_in_access_for_resources :except => [:new, :create, :destroy]

  # Not logged in tests {{{1
  context "GET :new" do
    setup do
      get :new
    end
    should assign_to(:instructor)
    should respond_with :success
    should render_template :new
  end

  context "POST :create" do
    setup do
      @f = Factory.attributes_for(:create_instructor)
      @old_count = Instructor.count
      post :create, :instructor => @f
      @i = Instructor.last
    end
    should "increase count by 1" do
      assert Instructor.count - @old_count == 1
    end
    should "not allow admin self promotion" do
      if @i.nil?
        assert false, "Instructor.last is nil"
      else
        assert !@i.admin?, "admin set to true"
      end
    end
    should "not allow notify_recipient self promotion" do
      if @i.nil?
        assert false, "Instructor.last is nil"
      else
        assert !@i.notify_recipient?, "notify_recipient set to true"
      end
    end
    should redirect_to("root") { root_url }
  end

  context "GET :emails" do
    setup do
      get :emails
    end
    # should assign_to(:emails)
    # should respond_with :success
    # should_have_json_array(@json)
    # should_have_json_elements([:label, :value], @json[0]) unless @json[0].nil?
  end

  # context "GET :emails with params[:term]" do
    # setup do
      # get :emails, :term => "example"
      # @json = construct_json_object(@response.body)
    # end
    # should assign_to(:emails)
    # should respond_with :success
    # should_have_json_array(@json)
    # should_have_json_elements([:label, :value], @json[0]) unless @json[0].nil?
  # end

  # logged in as :instructor tests {{{1
  logged_in_as :instructor do
    should_require_admin_access_for_resources :only => :index

    context "GET :show" do
      setup do
        @f = Factory(:instructor)
        get :show, :id => @f.id
      end
      should assign_to(:instructor)
      should respond_with :success
      should render_template :show
    end

    context "GET :edit instructor that is not current_instructor" do
      setup do
        @f = Factory(:instructor)
        get :edit, :id => @f.id
      end
      should_require_admin_access
    end

    context "PUT :update instructor that is not current_instructor" do
      setup do
        @f = Factory(:instructor)
        @f.phone = "test_update_model_instructor_field_phone"
        put :update, :id => @f.id, :instructor => @f.attributes
      end
      should_require_admin_access
    end

    context "GET :edit current_instructor" do
      setup do
        get :edit, :id => @current_instructor.id
      end
      should assign_to(:instructor)
      should respond_with :success
      should render_template :edit
    end

    context "PUT :update current_instructor" do
      setup do
        @current_instructor.office = "test_update_model_instructor_office_phone"
        put :update, :id => @current_instructor.id, :instructor => @current_instructor.attributes
      end
      should redirect_to(":instructor") { instructor_path(@current_instructor) }
    end
  end

  # logged in as :admin tests {{{1
  logged_in_as :admin do
    context "GET :index" do
      setup do
        get :index
      end
      should assign_to(:instructors)
      should respond_with :success
      should render_template :index
    end

    context "POST :create" do
      setup do
        @f = Factory.attributes_for(:create_instructor)
        post :create, :instructor => @f
        @i = Instructor.last
      end
      should "allow setting admin flag" do
        if @i.nil?
          assert false, "Instructor.last is nil"
        else
          assert @i.admin?, "admin set to false"
        end
      end
      should "allow setting notify_recipient flag" do
        if @i.nil?
          assert false, "Instructor.last is nil"
        else
          assert @i.notify_recipient?, "notify_recipient set to false"
        end
      end
    end
  end
  # }}}1
end
# vim:set sw=2 ts=2 et fdm=marker:
