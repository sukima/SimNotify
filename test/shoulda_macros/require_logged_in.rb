class Test::Unit::TestCase
  include ActionController::UrlWriter
  def self.should_require_logged_in(opt = { })
    opt[:method] ||= :get
    opt[:action] ||= :index
    opt[:login_path] ||= '/login'
    context "require a login to #{opt[:method].to_s} action #{opt[:action].to_s}" do
      setup do
        method(opt[:method]).call(opt[:action])
      end

      should redirect_to(opt[:login_path])
      should set_the_flash.to I18n.translate(:login_required)
    end
  end

  def self.should_require_admin(opt = { })
    opt[:method] ||= :get
    opt[:action] ||= :index
    opt[:root_path] ||= ''
    context "require administrator access to #{opt[:method].to_s} action #{opt[:action].to_s}" do
      setup do
        method(opt[:method]).call(opt[:action])
      end

      should redirect_to(opt[:root_path])
      should set_the_flash.to I18n.translate(:admin_required)
    end
  end
end
