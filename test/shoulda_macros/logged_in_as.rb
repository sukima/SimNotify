# Sets the current person in the session from the person fixtures.
class Test::Unit::TestCase
  def self.logged_in_as(person, &block)
    context "logged in as #{person.to_s}" do
      setup do
        @instructor = Factory(person)
        InstructorSession.create(@instructor)
      end

      yield
    end
  end

  def self.should_require_logged_in_access(opt={})
    opt[:flash] ||= I18n.translate(:login_required)

    should redirect_to(":login") { login_path }

    if opt[:flash]
      should set_the_flash.to(opt[:flash])
    end
  end

  def self.should_require_admin_access(opt={})
    opt[:flash] ||= I18n.translate(:admin_required)
    opt[:redirect] ||= false

    if opt[:redirect]
      if opt[:redirect].kind_of? String
        should redirect_to(opt[:redirect])
      else
        # There is a bug in the shoulda verion 2.11.3 that will not read the
        # descrition string sent to redirect_to. Upgrading to shoulda-matchers
        # and shoulda-contexts beta makes things worse because the set_flash_to
        # calls the ActionContoller's flash method which is protected in rails
        # 2.3 and Thoughtbot (makers of shoulda) don't believe in rails < 3.0
        # This means that the following will work to test but the outputed
        # description of the test is borked.
        should redirect_to(opt[:redirect].to_s) { send(opt[:redirect]) }
      end
    end

    if opt[:flash]
      should set_the_flash.to(opt[:flash])
    end
  end
end
