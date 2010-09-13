module EventsHelper
  def session_description(event)
    ret = h event.start_time
    ret += " (#{distance_of_time_in_words(event.start_time, event.end_time)})"
    ret += " - #{pluralize(event.scenarios.count, "senario")}"
    ret += h event.need_flags_as_words if event.collective_has_needs
    return ret
  end
end
