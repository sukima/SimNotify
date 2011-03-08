Factory.define :event do |e|
  e.location "here"
  e.benefit "none"
  e.notes "Lorem ipsum dolor sit amet."
  e.start_time DateTime.now + 2.days
  e.end_time DateTime.now + 2.days + 1.hour
  e.live_in true
  e.association :instructor
  #e.association :instructors # Should I need this?
  e.title "event title"
  e.submitted false
  e.approved false
  #e.scenarios [ ] # FIXME: This isn't right
  #e.association :scenarios, :factory => :scenario
end

Factory.define :submitted, :parent => :event do |e|
  e.title "submitted-title-test"
  e.submitted true
end

Factory.define :approved, :parent => :event do |e|
  e.title "approved-title-test"
  e.submitted true
  e.approved true
end

Factory.define :outdated, :parent => :event do |e|
  e.title "outdated-title-test"
  e.start_time DateTime.now - 2.days
  e.end_time DateTime.now + 1.hour - 2.days
end
