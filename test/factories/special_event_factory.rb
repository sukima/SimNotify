Factory.define :special_event do |e|
  e.sequence(:title) { |n| "special_event_title#{n}" }
  e.notes "no notes"
  e.start_time DateTime.now + 2.days
  e.end_time DateTime.now + 2.days + 1.hour
  e.all_day false
  e.association :instructor
end
