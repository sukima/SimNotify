# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def table_sorter(exclude_headers = [])
    javascript "jquery.tablesorter"
    stylesheet "tablesorter/style"
    ret = ""
    ret += "\n<script type=\"text/javascript\">\n"
    ret += "  $(document).ready(function () {\n"
    ret += "    $(\"#table_to_sort\").addClass(\"tablesorter\").tablesorter({\n"
    #ret += "      debug: true,\n"
    if !exclude_headers.empty?
      header_str = ""
      exclude_headers.each_with_index do |num, i|
        header_str += (i > 0) ? ", " : ""
        header_str += "#{num}: { sorter: false }"
      end
      ret += "      headers: { #{header_str} }\n"
    end
    ret += "    });\n"
    ret += "  });\n"
    ret += "</script>\n"
    return ret
  end

  def ie_footer
    <<-EOF
    <!--[if lt IE 7]>
      <div style='border: 1px solid #F7941D; background: #FEEFDA; text-align: center; clear: both; height: 75px; position: relative;'>
        <div style='position: absolute; right: 3px; top: 3px; font-family: courier new; font-weight: bold;'><a href='#' onclick='javascript:this.parentNode.parentNode.style.display="none"; return false;'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-cornerx.jpg' style='border: none;' alt='Close this notice'/></a></div>
        <div style='width: 640px; margin: 0 auto; text-align: left; padding: 0; overflow: hidden; color: black;'>
          <div style='width: 75px; float: left;'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-warning.jpg' alt='Warning!'/></div>
          <div style='width: 275px; float: left; font-family: Arial, sans-serif;'>
            <div style='font-size: 14px; font-weight: bold; margin-top: 12px;'>You are using an outdated browser</div>
            <div style='font-size: 12px; margin-top: 6px; line-height: 12px;'>For a better experience using this site, please upgrade to a modern web browser.</div>
          </div>
          <div style='width: 75px; float: left;'><a href='http://www.firefox.com' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-firefox.jpg' style='border: none;' alt='Get Firefox 3.5'/></a></div>
          <div style='width: 75px; float: left;'><a href='http://www.browserforthebetter.com/download.html' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-ie8.jpg' style='border: none;' alt='Get Internet Explorer 8'/></a></div>
          <div style='width: 73px; float: left;'><a href='http://www.apple.com/safari/download/' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-safari.jpg' style='border: none;' alt='Get Safari 4'/></a></div>
          <div style='float: left;'><a href='http://www.google.com/chrome' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-chrome.jpg' style='border: none;' alt='Get Google Chrome'/></a></div>
        </div>
      </div>
      <![endif]-->
    EOF
  end
end
