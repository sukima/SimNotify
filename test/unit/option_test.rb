require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  context "before_update" do
    context "with option 'system_email_recipients'" do
      setup do
        @option = Option.create(:name => "system_email_recipients", :value => nil)
      end
      should "sanatize value" do
        @option.value = ["1","3"]
        assert @option.save
        assert_equal [1,3], @option.value
      end
    end
  end
end
