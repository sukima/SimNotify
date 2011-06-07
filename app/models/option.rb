class Option < ActiveRecord::Base
  serialize :value
  before_update :sanatize_value

  def self.find_all_as_hash
    db_options = Option.all.index_by(&:name) # allows one database call instead of many.

    return self.set_all_defaults!(db_options)
  end

  def self.find_option_for(option_name)
    option = Option.find_by_name(option_name)
    option ||= self.create_default_for(option_name)
    return option
  end

  private
  def sanatize_value
    case name
    when "system_email_recipients"
      value.map! {|i| i.to_i}
    end
  end

  def self.set_all_defaults!(options={})
    [
      "system_email_recipients",
      "days_to_send_event_notifications"
    ].each do |o|
      options[o] ||= self.create_default_for(o)
    end

    return options
  end

  def self.create_default_for(option_name)
    case option_name
    when "system_email_recipients"
      # list of instructors that will receive email when changes occur
      return Option.create(:name => "system_email_recipients", :value => [])
    when "days_to_send_event_notifications"
      # Number of days to look for upcomming events.
      return Option.create(:name =>"days_to_send_event_notifications", :value => 2)
    else
      return Option.new(:name => option_name)
    end
  end
end
