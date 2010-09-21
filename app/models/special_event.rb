class SpecialEvent < ActiveRecord::Base
  include BaseEvent

  belongs_to :instructor

  validate :no_reverse_time_travel
end
