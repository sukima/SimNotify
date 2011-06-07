module CalendarHelper
  def agenda_event_descrition_for(event)
    str = "<em>#{event.title}</em> - #{session_description(event)}"
    str << " - <strong>#{event.technician.name}</strong>" unless event.technician.nil?
    return str
  end
end
