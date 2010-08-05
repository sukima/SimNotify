# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def stylesheet_link_jquery
    stylesheet_link_tag "smoothness/jquery-ui-1.8.2.custom.css"
  end

  def javascript_include_jquery
    ret = ""
    if APP_CONFIG['use_google_api']
      ret += javascript_include_tag "http://www.google.com/jsapi?key=#{APP_CONFIG['google_api_key']}"
      ret += javascript_include_tag "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"
      ret += javascript_include_tag "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.2/jquery-ui.min.js"
    else
      ret += javascript_include_tag "jquery"
      ret += javascript_include_tag "jquery-ui"
    end
    return ret
  end

  # See app/views/layouts/application.html.erb comments for why we are using
  # this helper method.
  def add_nav_link(*args)
    content_for(:nav_list) do
      rtn = "<li>"
      rtn += link_to *args
      rtn += "</li>"
    end
  end

  # builds a link that is dynamic for confirmation or not
  def link_to_confirm(title, path)
    if @confirm_exit.nil? || !@confirm_exit
      return link_to title, path
    else
      return link_to title, path, :confirm => t(:cancel_confirm)
    end
  end

  def link_to_home(title = nil)
    title = t(:home) if title.nil?
    link_to_confirm title, root_url
  end

  def confirm_on_exit
    @confirm_exit = true
  end
end
