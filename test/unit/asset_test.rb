require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  should belong_to :instructor
  should have_and_belong_to_many :events
  should_have_attached_file :session_asset
  should_validate_attachment_presence :session_asset
  should_validate_attachment_size :session_asset, :less_then => 20.megabytes
end
