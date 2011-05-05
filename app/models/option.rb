class Option < ActiveRecord::Base
  serialize :value
  before_update :sanatize_value

  private
  def sanatize_value
    case name
    when "system_email_recipients"
      value.map! {|i| i.to_i}
    end
  end
end
