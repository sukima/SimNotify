module CalendarHelper
  def agenda_event_descrition_for(event)
    str = "<em>#{event.title}</em> - #{session_description(event)}"
    if event.kind_of? Event
      if !event.technician.nil?
        str << " - <strong>#{event.technician.name}</strong>"
      end
    end
    return str
  end
end
