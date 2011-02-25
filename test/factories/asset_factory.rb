Factory.define :asset do |a|
  a.sequence(:session_asset_file_name) { |n| "fake#{n}.doc" }
  a.session_asset_content_type "application/msword"
  a.session_asset_file_size 25.kilobytes
  a.session_asset_updated_at Time.now
end

Factory.define :asset_attachment, :class => :asset do |a|
  include ActionController::TestProcess
  a.session_asset { fixture_file_upload("test_application_msword.doc", "application/msword") }
end
