# Sets the current person in the session from the person fixtures.
def logged_in_as(person, &block)
  context "logged in as #{person}" do
    setup do
      @instructor = Factory(instructor) if instructor.is_a? Symbol
      InstructorSession.create(instructor)
    end

    merge_block(&block)
  end
end
