module BaseEvent
  # Make sure the end time is not before the start time
  def no_reverse_time_travel
    return false if end_time.nil? && start_time.nil?
    if end_time <= start_time
      errors.add :end_time, I18n.translate(:no_reverse_time_travel)
      return false
    end
    return true
  end
end
