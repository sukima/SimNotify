require 'test_helper'

class SpecialEventTest < ActiveSupport::TestCase
  should belong_to :instructor
  should validate_presence_of :title
  should validate_presence_of :start_time
  should validate_presence_of :end_time

  # OPTIMIZE: This should be DRY!
  context "duration of special_event" do
    setup do
      assert @event = Factory.build(:special_event,
                                    :start_time => DateTime.now + 2.days,
                                    :end_time => DateTime.now - 2.days)
    end
    should "not travel backwards" do
      assert !@event.save
      assert_bad_value @event, :end_time, I18n.translate(:no_reverse_time_travel)
    end
  end
end
