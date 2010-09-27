Factory.define :manikin do |m|
  m.name "test_manikin"
  m.serial_number "000000000"
  m.sim_type "SimMan"
  m.oos false
  m.association :manikin_req_type
end
