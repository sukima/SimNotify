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

  def load_options
    options = Option.all.index_by(&:name) # allows one database call instead of many.

    # Load defaults if needed.
    # list of instructors that will receive email when changes occur
    options["system_email_recipients"] ||= Option.create(:name =>"system_email_recipients", :value => [])

    return options
  end
end
# vim:set ft=ruby:
