Factory.define :scenario do |s|
  s.equipment "foobar"
  s.staff_support true
  s.moulage true
  s.notes "Lorem ipsum dolor sit amet."
  s.support_material "Lorem ipsum dolor sit amet."
  s.description "Lorem ipsum dolor sit amet."
  s.video true
  s.mobile true
  s.association :event
  s.association :manikin
  s.association :manikin_req_type
end

Factory.define :scenario_no_needs, :parent => :scenario do |s|
  s.staff_support false
  s.moulage false
  s.video false
  s.mobile false
end
