class Test::Unit::TestCase
  class << self
    include ActionController::UrlWriter
    def should_require_logged_in(opt = { })
      opt.reverse_merge!({
        :method => :get,
        :action => :index,
        :redirect_to => '/login',
        :flash => nil,
        :factory => nil,
        :params => { }
      })
      should "require a login to #{opt[:method].to_s} action #{opt[:action].to_s}" do
        setup do
          if !opt[:factory].nil?
            @f = Factory.create(opt[:factory])
            opt[:params].merge!({ :id => @f.id })
          end
          method(opt[:method]).call(opt[:action], opt[:params])
        end

        # @flash = @controller.send(:flash)
        # #assert RedirectToMatcher(opt[:redirect_to]).matches?
        # if !opt[:flash].nil?
          # if Symbol === opt[:flash]
            # assert @flash.values.any? {|value| value == I18n.translate(opt[:flash])}
          # elsif Regex === opt[:flash]
            # assert @flash.values.any? {|value| value =~ opt[:flash]}
          # else
            # assert @flash.values.any? {|value| value == opt[:flash]}
          # end
        # end
      end
    end

    def should_require_admin(opt = { })
      opt[:redirect_to] = opt[:login_path] if opt[:login_path] && !opt[:redirect_to]
      opt.reverse_merge!({
        :method => :get,
        :action => :index,
        :redirect_to => '/',
        :flash => nil,
        :factory => nil,
        :params => { }
      })
      should "require administrator access to #{opt[:method].to_s} action #{opt[:action].to_s}" do
        setup do
          if !opt[:factory].nil?
            @f = Factory.create(opt[:factory])
            opt[:params].merge!({ :id => @f.id })
          end
          method(opt[:method]).call(opt[:action], opt[:params])
        end

        # @flash = @controller.send(:flash)
        # assert_redirected_to(opt[:redirect_to])
        # if !opt[:flash].nil?
          # if Symbol === opt[:flash]
            # assert @flash.values.any? {|value| value == I18n.translate(opt[:flash])}
          # elsif Regex === opt[:flash]
            # assert @flash.values.any? {|value| value =~ opt[:flash]}
          # else
            # assert @flash.values.any? {|value| value == opt[:flash]}
          # end
        # end
      end
    end

    def should_require_login_for_resources(options = { })
      should_require_for_resources(false, options)
    end

    def should_require_admin_for_resources(options = { })
      should_require_for_resources(true, options)
    end

    private
    def should_require_for_resources(admin, options = { })
      options.reverse_merge!({
        :except => [ ],
        :params => { :id => 1 }
      })

      if admin
        should_method = method(:should_require_admin)
      else
        should_method = method(:should_require_logged_in)
      end

      if options[:factory].blank?
        post_options = { :params => options[:params] }
      else
        post_options = { :factory => options[:factory] }
      end
      if !options[:redirect_to].blank?
        post_options[:redirect_to] = options[:redirect_to]
      elsif !options[:login_path].blank?
        post_options[:login_path] = options[:login_path]
      end

      unless Array(options[:except]).include?(:index)
        should_method.call :method => :get, :action => :index
      end

      unless Array(options[:except]).include?(:show)
        should_method.call post_options.merge({:method => :get, :action => :show})
      end

      unless Array(options[:except]).include?(:new)
        should_method.call :method => :get, :action => :new
      end

      unless Array(options[:except]).include?(:create)
        should_method.call :method => :post, :action => :create
      end

      unless Array(options[:except]).include?(:edit)
        should_method.call post_options.merge({:method => :get, :action => :edit})
      end

      unless Array(options[:except]).include?(:update)
        should_method.call post_options.merge({:method => :post, :action => :update})
      end

      unless Array(options[:except]).include?(:destroy)
        should_method.call post_options.merge({:method => :get, :action => :destroy})
      end
    end
  end
end
