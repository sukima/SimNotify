Factory.define :scenario_template do |s|
  s.title "test scenario template"
  s.equipment "foobar"
  s.staff_support false
  s.moulage false
  s.notes "Lorem ipsum dolor sit amet."
  s.support_material "Lorem ipsum dolor sit amet."
  s.description "Lorem ipsum dolor sit amet."
  s.video false
  s.mobile false
  s.association :manikin
end
