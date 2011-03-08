require 'test_helper'

class ManikinTest < ActiveSupport::TestCase
  setup do
    @m = Factory(:manikin)
  end

  should belong_to :manikin_req_type

  should validate_presence_of(:manikin_req_type).with_message('must be assigned')
  should validate_presence_of :name
  should validate_uniqueness_of :name
  should validate_presence_of :sim_type

  context "name and type format" do
    setup do
      assert @m = Factory(:manikin, :name => "a", :sim_type => "b")
      assert_respond_to @m, :name_and_type
    end
    should "be 'name (type)'" do
      assert_equal "a (b)", @m.name_and_type
    end
  end
end
