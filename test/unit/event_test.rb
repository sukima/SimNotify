require 'test_helper'

class EventTest < ActiveSupport::TestCase
  should belong_to :instructor
  should belong_to :technician
  should belong_to :facility
  should have_and_belong_to_many :instructors
  should have_and_belong_to_many :assets
  should have_many :scenarios

  should validate_presence_of :title
  should validate_presence_of :location
  should validate_presence_of :benefit
  should validate_presence_of :start_time
  should validate_presence_of :end_time

  context "duration of event" do
    setup do
      assert @event = Factory.build(:event,
                                    :start_time => DateTime.now + 2.days,
                                    :end_time => DateTime.now - 2.days)
    end
    should "not travel backwards" do
      assert !@event.save
      assert_bad_value @event, :end_time, I18n.translate(:no_reverse_time_travel)
    end
  end

  context "check_change_status" do
    setup do
      assert @event = Factory(:event)
      @event.submitted = true
      assert @event.save
    end
    should "prevent time changes after event submitted" do
      @event.start_time = DateTime.now + 4.days
      @event.end_time = DateTime.now + 4.days
      assert !@event.save
      assert_bad_value @event, :start_time, I18n.translate(:event_frozen)
      assert_bad_value @event, :end_time, I18n.translate(:event_frozen)
    end
  end

  context "check_submit_ok" do
    setup do
      assert @event = Factory(:event)
      @event.submit_note = "Test note"
    end
    should "prevent submition if no scenarios are associated" do
      assert !@event.save
      assert_bad_value @event, :submit_note, I18n.translate(:no_scenarios_attached)
    end
  end

  context "class find method" do
    context "self.submitted" do
      setup { assert @submitted = Factory(:submitted) }
      should "find all submitted" do
        @query = Event.submitted(:all)
        assert @query.count == 1
      end
    end
    context "self.approved" do
      setup { assert @approved = Factory(:approved) }
    end
    context "self.outdated" do
      setup { assert @outdated = Factory(:outdated) }
    end
  end

  context "collective_has_needs" do
    setup { assert @event = Factory.stub(:event) }
    should "return false with no needs" do
      @scenario = Factory(:scenario_no_needs)
      @event.scenarios = [ @scenario ]
      assert !@event.collective_has_needs
    end
    should "return true with staff_support" do
      @scenario = Factory(:scenario_no_needs, :staff_support => true)
      @event.scenarios = [ @scenario ]
      assert @event.collective_has_needs
    end
    should "return true with moulage" do
      @scenario = Factory(:scenario_no_needs, :moulage => true)
      @event.scenarios = [ @scenario ]
      assert @event.collective_has_needs
    end
    should "return true with video" do
      @scenario = Factory(:scenario_no_needs, :video => true)
      @event.scenarios = [ @scenario ]
      assert @event.collective_has_needs
    end
    should "return true with mobile" do
      @scenario = Factory(:scenario_no_needs, :mobile => true)
      @event.scenarios = [ @scenario ]
      assert @event.collective_has_needs
    end
  end

  context "missing_scenario?" do
    setup { assert @event = Factory(:event) }
    should "return true when assets and scenarios are empty" do
      assert @event.missing_scenario?
    end
    should "return false when assets assigned" do
      @event.assets = [ Factory(:asset) ]
      assert !@event.missing_scenario?
    end
    should "return false when scenario assigned" do
      @event.scenarios = [ Factory(:scenario) ]
      assert !@event.missing_scenario?
    end
  end

  context "outdated?" do
    setup { assert @event = Event.new }
    should "return false for new event" do
      @event.start_time = Time.now + 2.days
      assert !@event.outdated?, "returned true for 2.days from now"
    end
    should "return true for outdated event" do
      @event.start_time = 6.days.ago
      assert @event.outdated?, "returned false for 6.days.ago"
    end
  end
end
