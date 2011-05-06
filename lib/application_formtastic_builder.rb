class ApplicationFormtasticBuilder < Formtastic::SemanticFormBuilder
  def autocomplete_input(method, options = {})
    html_class = [ 'autocomplete' ]
    input_html = options[:input_html] || {}
    input_html[:class] = (html_class << input_html[:class]).flatten.compact.join(' ')
    options[:input_html] = input_html
    input method, options
  end

  def multiselect_input(method, options = {})
    html_class = [ 'multiselect' ]
    input_html = options[:input_html] || {}
    options[:multiple] = true
    input_html[:class] = (html_class << input_html[:class]).flatten.compact.join(' ')
    options[:input_html] = input_html
    select_input method, options
  end
end
