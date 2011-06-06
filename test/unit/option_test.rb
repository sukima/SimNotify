require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  context "before_update" do
    context "with option 'system_email_recipients'" do
      setup do
        @option = Factory(:system_email_recipients)
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

  context "create_default_for" do
    context "with system_email_recipients option" do
      setup do
        @option = Option.create_default_for("system_email_recipients")
      end
      should "return saved Option type" do
        assert @option.kind_of? Option
        assert !@option.new_record?
      end
    end
    context "with unknown option" do
      setup do
        @option = Option.create_default_for("unknown")
      end
      should "return saved Option type" do
        assert @option.kind_of? Option
        assert @option.new_record?
      end
    end
  end

  context "set_all_defaults!" do
    context "with passed in parameter" do
      setup do
        @options = { "system_email_recipients" => Factory(:system_email_recipients) }
        @returned_options = Option.set_all_defaults!(@options)
      end
      should "return return a hash" do
        assert @returned_options.kind_of? Hash
      end
      should "add days_to_send_event_notifications" do
        assert @returned_options.has_key?("days_to_send_event_notifications")
      end
    end
    context "without parameter" do
      setup do
        @returned_options = Option.set_all_defaults!
      end
      should "return return a hash" do
        assert @returned_options.kind_of? Hash
      end
      should "add days_to_send_event_notifications" do
        assert @returned_options.has_key?("days_to_send_event_notifications")
      end
    end
  end

  context "find_option_for" do
    setup do
      @option = Factory(:option)
      @returned_option = Option.find_option_for(@option.name)
    end
    should "return an Option object" do
      assert @returned_option.kind_of? Option
    end
  end
end
