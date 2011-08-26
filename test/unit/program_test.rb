require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  should belong_to :contact
  should belong_to :created_by

  should validate_presence_of :name
  should validate_presence_of :description
  should validate_presence_of :benifit
  should validate_presence_of :contact_id

  context "" do
    setup do
      Factory.create(:program)
    end
    should validate_uniqueness_of(:name).case_insensitive
  end
end
