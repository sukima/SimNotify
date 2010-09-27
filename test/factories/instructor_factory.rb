Factory.define :instructor do |i|
  i.name "first_name last_name"
  i.email "testemail@example.com"
  i.office "nowhere"
  i.phone "(555) 555-1234"
  i.admin false
  i.notify_recipient false
  i.gui_theme nil
  i.new_user false
  i.password "secret"
  i.password_confirmation "secret"
end

Factory.define :admin, :parent => :instructor do |i|
  i.admin true
end

Factory.define :new_instructor, :parent => :instructor do |i|
  i.new_user true
end
