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

  def facility_color(event)
    if event.kind_of? Event
      if event.approved? && !event.facility.nil?
        return event.facility.agenda_color
      elsif !event.approved
        return Option.find_option_for("not_approved_color").value
      end
    elsif event.kind_of? SpecialEvent
      return Option.find_option_for("special_event_color").value
    else
      return "#000"
    end
  end

  def facility_name(event)
    if event.kind_of? Event
      if !event.facility.nil?
        return h event.facility.name
      else
        return "Other"
      end
    elsif event.kind_of? SpecialEvent
      return (event.event_type.blank?) ? "Other" : h(event.event_type)
    else
      return "&nbsp;"
    end
  end

  def build_json_event(e, opt={ :eventMethod => :event_path, :allDay => :live_in? })
      json_event = {
        :start => e.start_time,
        :end => e.end_time,
      }
      if e.kind_of? Event
        if (e.instructor == current_instructor || is_admin?)
          json_event[:title] = e.title
          json_event[:url] = event_path(e)
        else
          json_event[:title] = "Session Scheduled"
        end
        json_event[:allDay] = e.live_in?
      elsif e.kind_of? SpecialEvent
        json_event[:title] = e.title
        json_event[:url] = special_event_path(e)
        json_event[:allDay] = e.all_day?
      end
      json_event[:color] = facility_color(e)
      return json_event
  end
end
