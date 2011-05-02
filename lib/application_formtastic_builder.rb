class ApplicationFormtasticBuilder < Formtastic::SemanticFormBuilder
  def autocomplete_input(method, options = {})
    input_html = options[:input_html] || {}
    html_class = [ 'autocomplete' ]
    input_html[:class] = (html_class << input_html[:class]).flatten.compact.join(' ')
    options[:input_html] = input_html
    text_input method, options
  end

  def multiselect_input(method, options = {})
    input_html = options[:input_html] || {}
    html_class = [ 'multiselect' ]
    input_html[:class] = (html_class << input_html[:class]).flatten.compact.join(' ')
    options[:input_html] = input_html
    select_input method, options
  end
end
