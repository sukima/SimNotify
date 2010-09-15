# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  def delete
    destroy
  end

  def event_owned_or_admin_check(event)
    if event.instructor != @current_instructor && !is_admin?
      flash[:error] = t(:permission_denied)
      return false
    else
      return true
    end
  end
end
