# Sets the current person in the session from the person fixtures.
class Test::Unit::TestCase # :nodoc:

  # Set the current state of being logged in.
  #
  # All tests who use logging in must also include the following in the
  # beginning part of the TestCase class:
  #
  #   class ProgramsControllerTest < ActionController::TestCase
  #     setup :activate_authlogic
  #   end
  #
  # Use this as a wrapper context. It uses a factory id to establish which user
  # to log in as. Depends on Factory_girl gem.
  #
  # Example:
  #
  #   logged_in_as :user do
  #     context "context A" do
  #       setup do
  #         .. Setup ..
  #       end
  #       should "do something" do
  #         .. Assert something ..
  #       end
  #     end
  #   end
  def self.logged_in_as(person, &block)
    context "logged in as #{person.to_s}" do
      setup do
        @instructor = Factory(person)
        InstructorSession.create(@instructor)
      end

      yield
    end
  end


  # Checks the redirect in the case of not being logged in correctly.
  #
  # This is designed to be called from should_check_logged_in_status and
  # therefore uses a lambda and not a block.
  #
  # Options:
  #
  #   redirect => String, Symbol, or lambda
  #
  # Examples:
  #
  #   should_check_logged_in_redirect( "/" ) # root_path
  #   should_check_logged_in_redirect( :root_path )
  #   should_check_logged_in_redirect( lambda { root_path } )
  #
  def self.should_check_logged_in_redirect(redirect)
    # There is a bug in the shoulda version 2.11.3 that will not read the
    # description string sent to redirect_to. Upgrading to shoulda-matchers
    # and shoulda-contexts beta makes things worse because the set_flash_to
    # calls the ActionContoller's flash method which is protected in rails
    # 2.3 and Thoughtbot (makers of shoulda) don't believe in rails < 3.0
    # This means that redirect_to will work to test with but the outputted
    # description of the test is borked.
    if redirect.kind_of? String
      should redirect_to(redirect)
    else
      if redirect.respond_to? :call
        # cannot derive value for description in this scope
        should redirect_to("") { redirect.call }
      elsif redirect.kind_of? Symbol
        should redirect_to(redirect.to_s) { send(redirect) }
      else
        # shouldn't get here but if we do lets cause an failed test.
        should "redirect" do
          assert false, "unable to test redirect_to with #{redirect.inspect}"
        end
      end
    end
  end


  # Checks that the flash was set in the case of not being logged in correctly.
  #
  # This is designed to be called from should_check_logged_in_status
  #
  # Options:
  #
  #   expected_flash => String or Regex (Optional)
  #
  # Examples:
  #
  #   should_check_logged_in_flash
  #   should_check_logged_in_flash("test denied")
  #   should_check_logged_in_flash(/test/)
  #
  def self.should_check_logged_in_flash(expected_flash=nil)
    if expected_flash.kind_of? String or expected_flash.kind_of? Regexp
      should set_the_flash.to(expected_flash)
    else
      should set_the_flash
    end
  end


  # Checks that the session return_to was set in the case of not being logged
  # in correctly.
  #
  # This is designed to be called from should_check_logged_in_status and
  # therefore uses a lambda and not a block.
  #
  # Options:
  #   return_to => String, Symbol, or lambda
  #
  # Examples:
  #
  #   should_check_logged_in_return_to( "/" ) # root_path
  #   should_check_logged_in_return_to( :root_path )
  #   should_check_logged_in_return_to( lambda { root_path } )
  #
  def self.should_check_logged_in_return_to(return_to)
    if return_to.kind_of? String
      should "set the :return_to session variable to #{return_to}" do
        assert_equal return_to, session[:return_to]
      end
    else
      should "set the :return_to session variable" do
        if return_to.respond_to? :call
          assert_equal self.instance_eval(&return_to), session[:return_to]
        elsif return_to.kind_of? Symbol
          assert_equal send(return_to), session[:return_to]
        else
          # shouldn't get here but if we do lets cause an failed test.
          assert false, "unable to test session[:return_to] with #{return_to.inspect}"
        end
      end
    end
  end


  # Checks the basic tests that are needed when a user is not logged in
  # correctly.
  #
  # Options:
  #
  #   opt => A hash with the key/values of
  #     :flash => See should_check_logged_in_flash()
  #     :redirect => See should_check_logged_in_redirect()
  #     :return_to => See should_check_logged_in_return_to()
  #
  def self.should_check_logged_in_status(opt)
    self.should_check_logged_in_flash(opt[:flash]) if opt[:flash]
    self.should_check_logged_in_redirect(opt[:redirect]) if opt[:redirect]
    self.should_check_logged_in_return_to(opt[:return_to]) if opt[:return_to]
  end


  # Convinience method to test if controller properly handled a user who is not
  # logged in.
  #
  # Options:
  #   opt => Hash of options (Optional). See should_check_logged_in_status().
  #
  # Defaults:
  #
  #   :flash => I18n translation of :login_required
  #   :redirect => login_path (See UrlHelper and routing)
  #   :return_to => Not checked
  #
  # Examples:
  #
  #   should_require_logged_in_access :flash => /test/, :return_to => "controller/index"
  #   should_require_logged_in_access :redirect => lambda { root_path }
  #
  def self.should_require_logged_in_access(opt={})
    opt[:flash] ||= I18n.translate(:login_required)
    opt[:redirect] ||= :login_path
    opt[:return_to] ||= false
    self.should_check_logged_in_status(opt)
  end


  # Convinience method to test if controller properly handled a user who is not
  # an admin.
  #
  # Options:
  #   opt => Hash of options (Optional). See should_check_logged_in_status().
  #
  # Defaults:
  #
  #   :flash => I18n translation of :admin_required
  #   :redirect => login_path (See UrlHelper and routing)
  #   :return_to => Not checked
  #
  # Examples:
  #
  #   should_require_admin_access :flash => /test/, :return_to => "controller/index"
  #   should_require_admin_access :redirect => lambda { root_path }
  #
  def self.should_require_admin_access(opt={})
    opt[:flash] ||= I18n.translate(:admin_required)
    opt[:redirect] ||= :login_path
    opt[:return_to] ||= false
    self.should_check_logged_in_status(opt)
  end
end
