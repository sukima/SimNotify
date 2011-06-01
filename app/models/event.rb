class Event < ActiveRecord::Base
  include BaseEvent
  attr_accessor :submit_note, :revoke_note

  belongs_to :instructor
  has_and_belongs_to_many :instructors
  has_and_belongs_to_many :assets
  has_many :scenarios
  belongs_to :technician, :class_name => "Instructor"
  belongs_to :facility

  validates_presence_of :title, :location, :benefit, :start_time, :end_time

  validate :no_reverse_time_travel, :check_change_status, :check_submit_ok

  protected
  # Prevent start and end time from changing if the sim has already been submitted
  def check_change_status
    ret_val = true
    if !new_record? && submitted?
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

  def check_submit_ok
    if !new_record? && !submit_note.blank? && missing_scenario?
      errors.add :submit_note, I18n.translate(:no_scenarios_attached)
      false
    else
      true
    end
  end

  public
  def self.in_queue(instructor)
    conditions = [ "submitted = ? AND approved = ? AND start_time > ?", false, false, Time.new ]
    if instructor == :all
      return Event.find(:all, :conditions => conditions)
    else
      return instructor.events.find(:all, :conditions => conditions)
    end
  end

  def self.submitted(instructor)
    conditions = [ "submitted = ? AND approved = ? AND start_time > ?", true, false, Time.new ]
    if instructor == :all
      return Event.find(:all, :conditions => conditions)
    else
      return instructor.events.find(:all, :conditions => conditions)
    end
  end

  def self.approved(instructor)
    conditions = [ "approved = ? AND start_time > ?", true, Time.new ]
    if instructor == :all
      return Event.find(:all, :conditions => conditions)
    else
      return instructor.events.find(:all, :conditions => conditions)
    end
  end

  def self.outdated(instructor)
    conditions = [ "start_time => ?", Time.new ]
    if instructor == :all
      return Event.find(:all, :conditions => conditions)
    else
      return instructor.events.find(:all, :conditions => conditions)
    end
  end

  def self.find_upcomming_approved(number_of_days=2)
    event_start_time = Time.now.beginning_of_day
    event_end_time = event_start_time + number_of_days.days
    conditions = [ "approved = ? AND start_time > ? AND start_time < ?", true, event_start_time, event_end_time ]
    return Event.find(:all, :conditions => conditions)
  end

  def collective_need_flags
    needs_hash = {
      :staff_support => false,
      :moulage => false,
      :video => false,
      :mobile => false
    }
    scenarios.each do |s|
      needs_hash[:staff_support] = true if s.staff_support
      needs_hash[:moulage] = true if s.moulage
      needs_hash[:video] = true if s.video
      needs_hash[:mobile] = true if s.mobile
    end
    return needs_hash
  end

  def collective_has_needs
    scenarios.each do |s|
      if s.staff_support || s.moulage || s.video || s.mobile
        return true
      end
    end
    return false
  end

  def need_flags_as_words
    needs = []
    needs_hash = collective_need_flags
    needs << "staff support" if needs_hash[:staff_support]
    needs << "moulage" if needs_hash[:moulage]
    needs << "video" if needs_hash[:video]
    needs << "mobile" if needs_hash[:mobile]
    return needs.to_sentence
  end

  def priority_request?
    !outdated? && (start_time - Time.now) < 172800 # 2 days, 60*60*24*2
  end

  def outdated?
    (start_time < Time.now)
  end

  def status_as_class
    if !submitted? && !approved?
      return "in-queue"
    elsif submitted? && !approved?
      return "waiting-approval"
    elsif approved?
      return "approved"
    else
      return nil
    end
  end

  def missing_scenario?
    has_document = false
    assets.each do |a|
      if not a.image?
        has_document = true
      end
    end
    !has_document && scenarios.empty?
  end
end
