Factory.define :program_submission do |p|
  p.sequence(:name) { |n| "fake_name_#{n}" }
  p.email "fake@email.xxx"
  p.department "fake department"
  p.summary "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  p.phone "555-555-5555"
end
