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

  def self.should_require_logged_inX(opt={})
    opt[:flash] ||= I18n.translate(:login_required)

    should redirect_to(":login") { login_path }

    if opt[:flash]
      should set_the_flash.to(opt[:flash])
    end
  end

  def self.should_require_adminX(opt={})
    opt[:flash] ||= I18n.translate(:admin_required)
    opt[:redirect] ||= false

    if opt[:redirect]
      if opt[:redirect].kind_of? String
        should redirect_to(opt[:redirect])
      else
        should redirect_to(opt[:redirect].to_s) { send(opt[:redirect]) }
      end
    end

    if opt[:flash]
      should set_the_flash.to(opt[:flash])
    end
  end
end
