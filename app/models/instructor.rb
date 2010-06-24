class Instructor < ActiveRecord::Base
  acts_as_authentic

  validates_presence_of :name
  validates_uniqueness_of :name
end
