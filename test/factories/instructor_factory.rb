Factory.define :instructor do |i|
  i.sequence(:name) { |n| "first_name#{n} last_name#{n}" }
  i.sequence(:email) { |n| "testemail#{n}@example.com" }
  i.office "nowhere"
  i.phone "(555) 555-1234"
  i.admin false
  i.notify_recipient false
  i.gui_theme nil
  i.new_user false
  i.password "secret_password"
  i.password_confirmation "secret_password"
end

Factory.define :create_instructor, :parent => :instructor do |i|
  i.admin true
  i.notify_recipient true
  i.new_user true
end

Factory.define :instructor_auth, :parent => :instructor do |i|
  # Prevents Authlogic from logging in automatically
  i.skip_session_maintenance true
end

Factory.define :admin, :parent => :instructor_auth do |i|
  i.admin true
end

Factory.define :new_instructor, :parent => :instructor_auth do |i|
  i.new_user true
end

Factory.define :technician, :parent => :instructor_auth do |i|
  i.admin true
  i.is_tech true
end
