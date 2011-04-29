Factory.define :option do |o|
  o.sequence(:name) { |n| "option#{n}" }
end
