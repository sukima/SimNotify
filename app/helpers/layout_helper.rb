# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  # Page information {{{1
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

  # jQuery {{{1
  def stylesheet_link_jquery
    ret = ""
    theme = (@current_instructor && !@current_instructor.gui_theme.nil?) ?
      @current_instructor.gui_theme : APP_CONFIG[:default_theme] 
    # Make sure to change the default path for the themes in
    # public/javascripts/application.js also.
    ret += stylesheet_link_tag "#{APP_CONFIG[:theme_dir]}/#{theme}/jquery.ui.all.css", :class => "theme"
    ret += stylesheet_link_tag "jquery-ui-timepicker-addon"
    ret += stylesheet_link_tag "jquery.multiselect"
    ret += stylesheet_link_tag "jquery.notifications"
    return ret
  end

  def javascript_include_jquery
    # min_ext = (APP_CONFIG[:use_minified_js]) ? ".min" : ""
    ret = ""
    if APP_CONFIG[:use_google_api]
      ret += javascript_include_tag("http://www.google.com/jsapi?key=#{APP_CONFIG[:google_api_key]}")
      ret += javascript_include_tag("http://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js")
      ret += javascript_include_tag("http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.10/jquery-ui.min.js")
    else
      ret += javascript_include_tag "jquery.min"
      ret += javascript_include_tag "jquery-ui.min"
    end
    ret += javascript_include_tag "jquery-ui-timepicker-addon"
    ret += javascript_include_tag "jquery.multiselect.min"
    ret += javascript_include_tag "jquery.icolorpicker.min"
    ret += javascript_include_tag "jquery.ba-dotimeout.min"
    ret += javascript_include_tag "jquery.notifications.min"
    ret += javascript_include_tag "jquery.hoverIntent.min"
    return ret
  end

  def javascript_logging
    if RAILS_ENV == "development"
      log_code = <<-EOF
        var alert_needed = true;
        var str = msg;
        if (!typeof msg === String) str = msg.toString();
        if (console && console.log) {
          console.log(str);
          alert_needed = false;
        }
        if ( $("#general_debug_info").length ) {
          $("<div/>").clone().html(str).appendTo("#general_debug_info");
          alert_needed = false;
        }
        if (alert_needed) alert(str);
      EOF
    else
      log_code = "/* Logging is only enabled in development environment. */"
    end

    "<script type=\"text/javascript\">\nAPP.log = function (msg) {\n#{log_code}\n};\n</script>\n"
  end

  # IE Bug Fixes {{{1
  def iebugfixes_include_tag
    #min_ext = (APP_CONFIG[:use_minified_js]) ? ".min" : ""
    #ret = ""
    #ret +=
    javascript_include_tag "jquery.bgiframe" # already minified
    #return ret
  end

  # Navigation buttons {{{1
  # See app/views/layouts/application.html.erb comments for why we are using
  # this helper method.
  def nav_link_to(title, path, opts=nil)
    opts ||= {}
    rtn = "<li>"
    rtn += link_to_confirm title, path, opts.merge({:is_button=>true})
    rtn += "</li>"
    return rtn
  end

  def link_to_sub_menu(name)
    return "<a href=\"#\" class=\"dropdown\">#{name}</a>"
  end

  def add_nav_link(title, path, opts=nil)
    content_for(:nav_list) do
      nav_link_to title, path, opts
    end
  end

  def nav_link_to_calendar
    nav_link_to "Calendar", calendar_path, { :icon => 'calendar' }
  end

  # Links {{{1
  def link_to_with_icon(title, path, opts=nil)
    if opts[:icon]
      if opts[:is_button]
        opts[:icon_pos] ||= "w"
        opts["data-button-icon"] = "ui-icon-#{opts[:icon]}"
        opts["data-button-icon-pos"] = opts[:icon_pos]
      else
        if opts[:icon_pos] =~ /[rRwW]/
          title = "#{title}<span class=\"ui-icon ui-icon-#{opts[:icon]}\"></span>"
        else
          title = "<span class=\"ui-icon ui-icon-#{opts[:icon]}\"></span>#{title}"
        end
      end
    end
    opts[:class] ||= "button" if opts[:is_button] or opts[:btn_icon_pos]
    opts.delete(:is_button)
    opts.delete(:btn_icon_pos)
    opts.delete(:icon)
    return link_to title, path, opts
  end

  # builds a link that is dynamic for confirmation or not
  def link_to_confirm(title, path, opts=nil)
    opts = {} if opts.nil?
    if !opts[:no_confirm]
      if opts[:confirm] || @confirm_exit
        opts[:confirm] ||= t(:cancel_confirm)
        opts[:confirm_message] = opts[:confirm]
      end
    else
      opts.delete(:no_confirm)
    end
    return link_to_with_icon title, path, opts
  end

  def link_icon_to(icon, title, path, opts=nil)
    opts = {} if opts.nil?
    opts[:class] ||= ""
    opts[:class] = "ui-icon ui-icon-#{icon} #{opts[:class]}"
    opts[:title] = title if opts[:title].nil?
    opts.delete(:icon) # Prevent redundant icons
    return link_to_confirm title, path, opts
  end

  def nav_link_to_help(title = nil)
    title ||= t(:help)
    return nav_link_to title, help_path, {:id => 'nav_help_link', :icon => 'help', :no_confirm => true}
  end

  def link_to_home(title = nil)
    title = t(:home) if title.nil?
    link_to_confirm title, root_url, { :icon => 'home', :is_button => true }
  end

  def link_to_event_submit(title, event, use_icon=false)
    if use_icon
      link_icon_to "calendar", title, submit_event_path(event), {:confirm => t(:submit_confirm, :company_name => APP_CONFIG[:company_name])}
    else
      link_to_confirm title, submit_event_path(event), {:confirm => t(:submit_confirm, :company_name => APP_CONFIG[:company_name])}
    end
  end

  def link_to_event_revoke(title, event, use_icon=false)
    if use_icon
      link_icon_to "cancel", title, revoke_event_path(event), {:confirm => t(:revoke_confirm, :company_name => APP_CONFIG[:company_name])}
    else
      link_to_confirm title, revoke_event_path(event), {:confirm => t(:revoke_confirm, :company_name => APP_CONFIG[:company_name])}
    end
  end

  # Page variables {{{1
  def confirm_on_exit
    @confirm_exit = true
  end

  def wide_content(val = true)
    @wide_content = val
  end

  def wide_content?
    @wide_content
  end

  def force_display_help(val = true)
    @force_display_help = val
  end

  def force_display_help?
    @force_display_help
  end

  # Dates {{{1
  def d(the_date)
    the_date.strftime("%A, %b %d")
  end

  def dt(the_datetime)
    the_datetime.strftime("%A, %b %d %H:%M")
  end

  def ftime(the_time)
    the_time.strftime("%H:%M")
  end

  # name_with_gravatar {{{1
  def name_with_gravatar(instructor, option = {})
    option[:pos] ||= :left
    option[:link] ||= true
    if option[:link]
      if option[:link].kind_of? String
        name = link_to h(instructor.name), option[:link]
      else
        name = link_to h(instructor.name), instructor
      end
    else
      name = h(instructor.name)
    end
    ret = ""
    ret += name if option[:pos] == :right
    ret += "<span class=\"grav-mini-icon\">"
    ret += image_tag(instructor.gravatar_url(:size=>16), :size=>"16x16")
    ret += "</span>"
    ret += name if option[:pos] == :left
    ret
  end

  # control_box {{{1
  def control_box(title=nil, &block)
    if title
      contents = "<span class=\"control-box-title\">#{title}</span>\n"
    else
      contents = ''
    end

    if block_given?
      contents += if @template.respond_to?(:is_haml?) && @template.is_haml?
                    @template.capture_haml(&block)
                  else
                    @template.capture(&block)
                  end
    end

    <<-EOF
      <script type="text/javascript">
        $(function() {
          APP.appendToNavBar("#controls");
        });
      </script>
      <div id="controls" class="ui-widget ui-widget-header ui-corner-all">
        #{contents}
      </div>
    EOF
  end
  # }}}1
end

# vim:set et ts=2 sw=2 fdm=marker:
