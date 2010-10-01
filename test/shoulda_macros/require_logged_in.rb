module Shoulda
  module SimNotify

    module Matchers
      def require_logged_in(action)
        RequireLoggedInMatcher.new(action)
      end

      def require_admin(action)
        RequireAdminMatcher.new(action)
      end

      class RequireLoggedInMatcher
        def initialize(action)
          @check_action = action
          @use_method = :get
        end

        def for_method(method)
          @use_method = method
          self
        end

        def matches?(subject)
          if @use_method == :post
            post @check_action
          else
            get @check_action
          end
          RedirectToMatcher.new(login_path).matcher?
        end

        def description
          "require user to log in for #{@check_action.to_s} action"
        end
      end

      class RequireAdminMatcher
        def initialize(action)
          @check_action = action
          @use_method = :get
        end

        def for_method(method)
          @use_method = method
          self
        end

        def matcher?
          if @use_method == :post
            post @check_action
          else
            get @check_action
          end
          SetTheFlashMatcher.new.to(I18n.translate(:admin_required)).matches?
        end

        def description
          "require administrator access for #{@check_action.to_s} action"
        end
      end
    end

  end
end
