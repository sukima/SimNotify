# This module is included in your application controller which makes
# several methods available to all controllers and views. Here's a
# common example you might add to your application layout file.
# 
#   <% if logged_in? %>
#     Welcome <%=h current_instructor.username %>! Not you?
#     <%= link_to "Log out", logout_path %>
#   <% else %>
#     <%= link_to "Sign up", signup_path %> or
#     <%= link_to "log in", login_path %>.
#   <% end %>
# 
# You can also restrict unregistered users from accessing a controller using
# a before filter. For example.
# 
#   before_filter :login_required, :except => [:index, :show]
module Authentication
  def self.included(controller)
    controller.send :helper_method, :current_instructor, :logged_in?, :is_admin?, :redirect_to_target_or_default

    # Scrub sensitive parameters from your log
    controller.filter_parameter_logging :password
    controller.filter_parameter_logging :password_confirmation
  end
  
  def current_instructor_session
    return @current_instructor_session if defined?(@current_instructor_session)
    @current_instructor_session = InstructorSession.find
  end

  def current_instructor
    return @current_instructor if defined?(@current_instructor)
    @current_instructor = current_instructor_session && current_instructor_session.record
  end
  
  def logged_in?
    current_instructor
  end

  def is_admin?
    logged_in? && current_instructor.admin?
  end
  
  def login_required
    unless logged_in?
      flash[:error] = "You must first log in or sign up before accessing this page."
      store_target_location
      redirect_to login_url
    end
  end

  def login_admin
    unless logged_in? && current_instructor.admin?
      flash[:error] = "You must be an administrator to access that page"
      store_target_location
      redirect_to root_url
    end
  end
  
  def redirect_to_target_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  private
  
  def store_target_location
    session[:return_to] = request.request_uri
  end
end
