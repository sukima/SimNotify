require 'test_helper'

class ProgramSubmissionTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:email)
  should validate_presence_of(:department)
  should validate_presence_of(:summary)
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
end
