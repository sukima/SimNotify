Factory.define :manikin do |m|
  m.sequence(:name) { |n| "test_manikin#{n}" }
  m.sequence(:serial_number) { |n| "000#{n}" }
  m.sim_type "SimMan"
  m.oos false
  m.association :manikin_req_type
end
