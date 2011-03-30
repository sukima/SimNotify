require 'test_helper'

class ScenarioTest < ActiveSupport::TestCase
  should belong_to :event
  should belong_to :manikin_req_type
  should belong_to :manikin

  should validate_presence_of :title

  context "flags_as_strings" do
    setup do
      assert @scenario = Factory(:scenario)
      assert_respond_to @scenario, :flags_as_strings
      assert @flags = @scenario.flags_as_strings
    end
    should "return a proper array of strings" do
      assert_not_nil @flags
      assert_kind_of Array, @flags
      assert_equal 4, @flags.count
      @flags.each { |f| assert_kind_of String, f }
    end
  end
end
