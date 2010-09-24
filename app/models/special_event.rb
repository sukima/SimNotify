class SpecialEvent < ActiveRecord::Base
  include BaseEvent

  belongs_to :instructor

  validates_presence_of :title
  validate :no_reverse_time_travel

  def status_as_class
    "special-event"
  end
end
