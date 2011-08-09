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

  def self.value_for(option_name)
    Option.find_option_for(option_name).value
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
      "scheduler_phone",
      "days_to_send_event_notifications",
      "not_approved_color",
      "gravatar_default",
      "special_event_color"
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
    when "scheduler_phone"
      # Phone number for the scheduling secretary.
      return Option.create(:name => "scheduler_phone", :value => "")
    when "days_to_send_event_notifications"
      # Number of days to look for upcomming events.
      return Option.create(:name =>"days_to_send_event_notifications", :value => 2)
    when "not_approved_color"
      # The color for not approved events in calendar
      return Option.create(:name => "not_approved_color", :value => "#f00")
    when "special_event_color"
      # The color for special events in calendar
      return Option.create(:name => "special_event_color", :value => "#f90")
    when "gravatar_default"
      # The default gravatar icons to use ("identicon", "monsterid", "wavatar")
      return Option.create(:name => "gravatar_default", :value => "wavatar")
    else
      return Option.new(:name => option_name)
    end
  end
end
