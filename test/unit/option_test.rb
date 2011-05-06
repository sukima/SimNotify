require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  context "before_update" do
    context "with option 'system_email_recipients'" do
      setup do
        @option = Factory(:option)
      end
      should "sanatize value" do
        @option.value = ["1","3"]
        assert @option.save
        assert_equal [1,3], @option.value
      end
    end
  end
  context "find_all_as_hash()" do
    setup do
      @the_option = Factory(:option)
      @options = Option.find_all_as_hash
    end
    should "return a hash of Option objects by name" do
      assert @options.kind_of? Hash
      assert @options[@the_option.name].kind_of? Option
    end
  end
end
