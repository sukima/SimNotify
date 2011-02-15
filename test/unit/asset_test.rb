require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  should belong_to :instructor
  should have_and_belong_to_many :events
end
