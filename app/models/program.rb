# Attributes:
#   Name        => String
#   Description => Text
#   Benifit     => Text
#   Contact     => Association(Instructor)
#   Created_by  => Association(Instructor) # Must be set via controller
#                  with Program.new(:created_by => @current_instructor)
class Program < ActiveRecord::Base
  belongs_to :contact, :class_name => "Instructor"
  belongs_to :created_by, :class_name => "Instructor"

  validates_presence_of :name, :description, :benifit, :contact_id
  validates_uniqueness_of :name
end
