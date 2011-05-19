class ApplicationFormtasticBuilder < Formtastic::SemanticFormBuilder
  def autocomplete_input(method, options = {})
    options[:input_html] = merge_input_html(options[:input_html], 'autocomplete')
    input method, options
  end

  def multiselect_input(method, options = {})
    options[:multiple] = true
    options[:input_html] = merge_input_html(options[:input_html], 'multiselect')
    select_input method, options
  end

  def slider_input(method, options = {})
    options[:include_blank] = false
    options[:input_html] = merge_input_html(options[:input_html], 'slider')
    select_input method, options
  end

  private
  def merge_input_html(input_html, html_class)
    input_html ||= {}
    html_class = [ html_class ] if html_class.kind_of? String
    html_class = [ ] if !html_class.kind_of? Array
    input_html[:class] = (html_class << input_html[:class]).flatten.compact.join(' ')
    return input_html
  end
end
