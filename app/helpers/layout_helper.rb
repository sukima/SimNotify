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
    theme = (@current_instructor && !@current_instructor.gui_theme.nil?) ?
      @current_instructor.gui_theme : APP_CONFIG[:gui_themes][0] 
    stylesheet_link_tag "themes/#{theme}/jquery-ui-1.8.4.custom.css"
  end

  def javascript_include_jquery
    ret = ""
    if APP_CONFIG[:use_google_api]
      ret += javascript_include_tag("http://www.google.com/jsapi?key=#{APP_CONFIG[:google_api_key]}").sub('.js', '')
      ret += javascript_include_tag("http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js").sub('.js', '')
      ret += javascript_include_tag("http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.4/jquery-ui.min.js").sub('.js', '')
    else
      ret += javascript_include_tag "jquery"
      ret += javascript_include_tag "jquery-ui"
    end
    ret += javascript_include_tag "jquery.timepickr"
    #ret += stylesheet_link_tag "ui.timepickr"
    return ret
  end

  # See app/views/layouts/application.html.erb comments for why we are using
  # this helper method.
  def nav_link_to(*args)
    rtn = "<li>"
    rtn += link_to_confirm *args
    rtn += "</li>"
    return rtn
  end

  def add_nav_link(*args)
    content_for(:nav_list) do
      nav_link_to *args
    end
  end

  def nav_link_to_calendar
    nav_link_to "Calendar", calendar_path
  end

  # builds a link that is dynamic for confirmation or not
  def link_to_confirm(title, path, message=nil)
    if message.nil? && (@confirm_exit.nil? || !@confirm_exit)
      return link_to title, path
    else
      message = t(:cancel_confirm) if message.nil?
      return link_to title, path, :confirm => message,
        :confirm_message => message
    end
  end

  def link_to_home(title = nil)
    title = t(:home) if title.nil?
    link_to_confirm title, root_url
  end

  def confirm_on_exit
    @confirm_exit = true
  end

  def wide_content(val = true)
    @wide_content = val
  end

  def wide_content?
    @wide_content
  end
end
