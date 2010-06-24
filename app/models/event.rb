class Event < ActiveRecord::Base
  belongs_to :instructor

  validates_presence_of :location, :benefit
end
