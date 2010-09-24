# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Instructor.create({
  :name             => "Administrator Admin",
  :email            => "admin@example.com",
  :admin            => true,
  :password         => "admin",
  :password_confirmation => "admin",
  :notify_recipient => false,
  :new_user         => false
})

ManikinReqType.create([
  { :req_type => "New Born" },
  { :req_type => "Infant" },
  { :req_type => "Child" },
  { :req_type => "Adult" },
  { :req_type => "Birthing" }
])
