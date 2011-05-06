class Option < ActiveRecord::Base
  serialize :value
  before_update :sanatize_value

  def self.find_all_as_hash
    options = Option.all.index_by(&:name) # allows one database call instead of many.

    # Load defaults if needed.
    # list of instructors that will receive email when changes occur
    options["system_email_recipients"] ||= Option.create(:name =>"system_email_recipients", :value => [])

    return options
  end

  private
  def sanatize_value
    case name
    when "system_email_recipients"
      value.map! {|i| i.to_i}
    end
  end
end
