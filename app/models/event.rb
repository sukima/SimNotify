class Event < ActiveRecord::Base
  attr_accessor :submit_note

  belongs_to :instructor
  has_many :scenarios

  validates_presence_of :title, :location, :benefit, :start_time, :end_time

  validate :no_reverse_time_travel

  before_update :check_change_status
  
  protected
  # Make sure the end time is not before the start time
  def no_reverse_time_travel
    return false if end_time.nil? && start_time.nil?
    if end_time <= start_time
      errors.add :end_time, I18n.translate(:no_reverse_time_travel)
      return false
    end
    return true
  end
  
  # Prevent start and end time from changing if the sim has already been submitted
  def check_change_status
    ret_val = true
    if submitted?
      if start_time_changed?
        errors.add :start_time, I18n.translate(:event_frozen)
        ret_val = false
      end
      if end_time_changed?
        errors.add :end_time, I18n.translate(:event_frozen)
        ret_val = false
      end
    end
    return ret_val
  end
end
