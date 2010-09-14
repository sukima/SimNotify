class Event < ActiveRecord::Base
  attr_accessor :submit_note, :revoke_note

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

  public
  def self.in_queue(instructor)
    conditions = [ "submitted = 'f' AND approved = 'f' AND start_time > ?", Time.new ]
    if instructor == :all
      return Event.find(:all, :conditions => conditions)
    else
      return instructor.events.find(:all, :conditions => conditions)
    end
  end

  def self.submitted(instructor)
    conditions = [ "submitted = 't' AND approved = 'f' AND start_time > ?", Time.new ]
    if instructor == :all
      return Event.find(:all, :conditions => conditions)
    else
      return instructor.events.find(:all, :conditions => conditions)
    end
  end

  def self.approved(instructor)
    conditions = [ "approved = 't' AND start_time > ?", Time.new ]
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
      if s.staff_support || s.moulage || s.video || mobile
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
    (start_time - Time.now) < 172800 # 2 days, 60*60*24*2
  end

  def status_as_class
    if submitted? && !approved?
      return "waiting-approval"
    elsif approved?
      return "approved"
    else
      return nil
    end
  end
end
