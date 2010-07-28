class Event < ActiveRecord::Base
  attr_accessor :submit_note

  belongs_to :instructor
  has_many :scenarios

  validates_presence_of :title, :location, :benefit

  before_update :check_change_status
  
  protected
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
