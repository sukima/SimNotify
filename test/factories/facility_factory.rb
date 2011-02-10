Factory.define :facility do |f|
  f.sequence :name, { |n| "facility_name#{n}" }
end
