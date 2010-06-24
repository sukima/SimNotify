class Event < ActiveRecord::Base
  belongs_to :instructor
  has_many :scenarios

  validates_presence_of :location, :benefit
end