Factory.define :option do |o|
  o.sequence(:name) { |n| "option#{n}" }
end

Factory.define :system_email_recipients, :parent => :option do |o|
  o.name "system_email_recipients"
  o.value [ ]
end
