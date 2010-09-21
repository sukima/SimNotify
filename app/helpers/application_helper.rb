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
end
