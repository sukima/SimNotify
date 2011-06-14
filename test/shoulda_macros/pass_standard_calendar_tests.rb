class Test::Unit::TestCase
  class << self
    def should_pass_standard_calendar_tests
      should respond_with :success
      should respond_with_content_type(/json/)
      context "the json object" do
        should "be valid" do
          assert the_json = ActiveSupport::JSON.decode(@response.body)
          assert_not_nil the_json, "possible exception thrown in setup (response: #{@response.body})"
          assert the_json.kind_of? Array
          assert_not_nil the_json[0]
          assert the_json[0].kind_of? Hash
        end
        should "have a title" do
          assert_not_nil @json[0]['title']
        end
        should "have a start and end time" do
          assert_not_nil @json[0]['start']
          assert_not_nil @json[0]['end']
        end
      end
    end
  end
end
