class ApplicationFormtasticBuilder < Formtastic::SemanticFormBuilder
  def autocomplete_input(method, options = {})
    input_html = { :class => 'autocomplete' }
    input_html = options[:input_html].merge(input_html) unless options[:input_html].nil?
    options = options.merge({ :input_html => input_html })
    input method, options
  end
end
