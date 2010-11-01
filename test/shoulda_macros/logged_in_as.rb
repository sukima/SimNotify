# Sets the current person in the session from the person fixtures.
class Test::Unit::TestCase
  def self.logged_in_as(person, &block)
    context "logged in as #{person.to_s}" do
      setup do
        InstructorSession.create(Factory(person))
      end

      yield
    end
  end
end
