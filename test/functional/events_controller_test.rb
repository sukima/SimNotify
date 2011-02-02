require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  should_map_resources :events

  should route(:get, "/events/1/submit").to(:action => :submit, :id => 1)
  should route(:get, "/events/1/revoke").to(:action => :revoke, :id => 1)
  should route(:put, "/events/1/approve").to(:action => :approve, :id => 1)
  should route(:put, "/events/approve_all").to(:action => :approve_all)

  should_require_login_for_resources

  logged_in_as :instructor do
    should_require_admin_for_resources :except => [:index, :new, :create, :update, :destroy],
      :flash => :permission_denied,
      :factory => :event

    context "" do
      setup do
        @f = Factory(:event, :instructor => @instructor)
        ApplicationMailer.stubs(:deliver_submitted_email)
        ApplicationMailer.stubs(:deliver_approved_email)
        ApplicationMailer.stubs(:deliver_revoked_email)
      end

      context "GET :index" do
        setup do
          get :index, :mod => "foo"
        end
        should assign_to(:events)
        should assign_to(:listing_mod)
        should respond_with :success
        should render_template :index
      end

      context "GET :show" do
        setup do
          get :show, :id => @f.id
        end
        should assign_to(:event)
        should respond_with :success
        should render_template :show
      end

      context "GET :new" do
        setup do
          get :new
        end
        should assign_to(:event)
        should respond_with :success
        should render_template :new
      end

      context "POST :create" do
        setup do
          @f = Factory.build(:event, :instructor => @instructor)
          @old_count = Event.count
          post :create, :event => @f.attributes
        end
        should "increase count by 1" do
          assert Event.count - @old_count == 1
        end
        should redirect_to(":show") { event_path(Event.last) }
      end

      context "GET :edit" do
        setup do
          get :edit, :id => @f.id
        end
        should assign_to(:event)
        should respond_with :success
        should render_template :edit
      end

      context "GET :submit" do
        setup do
          get :submit, :id => @f.id
        end
        should assign_to(:event)
        should respond_with :success
        should render_template :submit
      end

      context "GET :revoke" do
        setup do
          get :revoke, :id => @f.id
        end
        should assign_to(:event)
        should respond_with :success
        should render_template :revoke
      end

      should_require_admin({
        :method => :get,
        :action => :approve,
        :facory => :event,
        :flash => :permission_denied
      })

      should_require_admin({
        :method => :get,
        :action => :approve_all,
        :flash => :permission_denied
      })

      context "PUT :update" do
        context "" do
          setup do
            @f.title = "test_update_model_event_field_title"
            put :update, :id => @f.id, :event => @f.attributes
          end
          should redirect_to(":show") { event_path(@f) }
        end

        context "with submit_note" do
          setup do
            put :update, :id => @f.id, :event => { :submit_note => "test submit note" }
          end
          should set_the_flash.to(/submitted/)
          should redirect_to('/') { root_path }
        end

        context "with revoke_note" do
          setup do
            put :update, :id => @f.id, :event => { :revoke_note=> "test revoke note" }
          end
          should set_the_flash.to(/revoked/)
          should redirect_to(':show') { event_path(@f) }
        end
      end

      context "GET :destroy" do
        setup do
          @old_count = Event.count
          delete :destroy, :id => @f.id
        end
        should "decrease count by 1" do
          assert Event.count - @old_count == -1
        end
        should redirect_to(":index") { events_path }
      end
    end
  end

  logged_in_as :admin do
    context "" do
      setup do
        @f = Factory.create(:event, :instructor => @instructor)
        ApplicationMailer.stubs(:deliver_submitted_email)
        ApplicationMailer.stubs(:deliver_approved_email)
        ApplicationMailer.stubs(:deliver_revoked_email)
      end

      context "GET :approve" do
        setup do
          put :approve, :id => @f.id
        end
        should set_the_flash.to(/approved/)
        should redirect_to(":show") { event_path(@f) }
      end

      context "GET :approve_all" do
        setup do
          put :approve_all, :event_ids => [ @f.id ]
        end
        should set_the_flash.to(/approved/)
        should redirect_to(":index") { events_path }
      end
    end
  end
end
