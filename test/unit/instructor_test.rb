require 'test_helper'

class InstructorTest < ActiveSupport::TestCase
  setup do
    @instructor = Factory(:instructor)
  end
  should_have_authlogic

  should have_many(:events)

  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should_not allow_value("name_with_no_space").for(:name)

  should validate_presence_of(:email)

  %w(
    (203)\ 555-1234
    (203)555-1234
    203\ 555\ 1234
    203-555-1234
    203.555.1234
    2035551234
  ).each do |value|
    should allow_value(value).for(:phone)
  end

  %w(5551234 555-1234 555.1234).each do |value|
    should_not allow_value(value).for(:phone)
  end

  context "parse_name" do
    should "return false if value is not a string" do
      assert !Instructor.parse_name(nil)
    end
    context "with value 'first last'" do
      setup { assert @parsed_name = Instructor.parse_name("first last") }
      should "find first and last name" do
        assert_equal "first", @parsed_name[:first_name]
        assert_equal "last", @parsed_name[:last_name]
        assert_nil @parsed_name[:suffix]
        assert_nil @parsed_name[:prefix]
        assert_nil @parsed_name[:middle_name]
      end
    end
    context "with value 'last, first'" do
      setup { assert @parsed_name = Instructor.parse_name("last, first") }
      should "find first and last name" do
        assert_equal "first", @parsed_name[:first_name]
        assert_equal "last", @parsed_name[:last_name]
        assert_nil @parsed_name[:suffix]
        assert_nil @parsed_name[:prefix]
        assert_nil @parsed_name[:middle_name]
      end
    end
    context "with value 'Mr. first last'" do
      setup { assert @parsed_name = Instructor.parse_name("Mr. first last") }
      should "find prefix, first and last name" do
        assert_equal "first", @parsed_name[:first_name]
        assert_equal "last", @parsed_name[:last_name]
        assert_nil @parsed_name[:suffix]
        assert_equal "Mr.", @parsed_name[:prefix]
        assert_nil @parsed_name[:middle_name]
      end
    end
    context "with value 'Mr. and Mrs. first last'" do
      setup { assert @parsed_name = Instructor.parse_name("Mr. and Mrs. first last") }
      should "find prefix, first and last name" do
        assert_equal "first", @parsed_name[:first_name]
        assert_equal "last", @parsed_name[:last_name]
        assert_nil @parsed_name[:suffix]
        assert_equal "Mr. and Mrs.", @parsed_name[:prefix]
        assert_nil @parsed_name[:middle_name]
      end
    end
    context "with value 'first last MD'" do
      setup { assert @parsed_name = Instructor.parse_name("first last MD") }
      should "find first, last and suffix name" do
        assert_equal "first", @parsed_name[:first_name]
        assert_equal "last", @parsed_name[:last_name]
        assert_equal "MD", @parsed_name[:suffix]
        assert_nil @parsed_name[:prefix]
        assert_nil @parsed_name[:middle_name]
      end
    end
    context "with value 'first middle last'" do
      setup { assert @parsed_name = Instructor.parse_name("first middle last") }
      should "find first, last and suffix name" do
        assert_equal "first", @parsed_name[:first_name]
        assert_equal "last", @parsed_name[:last_name]
        assert_nil @parsed_name[:suffix]
        assert_nil @parsed_name[:prefix]
        assert_equal "middle", @parsed_name[:middle_name]
      end
    end
  end
end
