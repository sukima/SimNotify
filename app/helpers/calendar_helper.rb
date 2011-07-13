module CalendarHelper
  def agenda_event_description_for(event)
    str = "<em>#{event.title}</em>"
    str << " #{ftime event.start_time} - #{ftime event.end_time}"
    str << " (#{distance_of_time_in_words(event.start_time, event.end_time)})"
    if event.kind_of? Event
      ret << " <em>#{h event.location}</em>"
      ret << " #{h event.need_flags_as_words}" if event.collective_has_needs
      if !event.technician.nil?
        str << " <strong>#{event.technician.name}</strong>"
      end
    end
    return str
  end
end
