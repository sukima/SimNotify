class Scenario < ActiveRecord::Base
  belongs_to :event
  belongs_to :manikin
end
