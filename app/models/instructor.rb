class Instructor < ActiveRecord::Base
  has_many :events
  acts_as_authentic

  validates_presence_of :name, :email
  validates_uniqueness_of :name
  validates_each :name do |record, attr, value|
    hash = self.parse_name(value)
    record.errors.add attr, 'must have a first and last name' if
      ( hash[:first_name].nil? || hash[:last_name].nil? )
  end

  def name_hash
    Instructor.parse_name(name)
  end

  # http://gist.github.com/491187
  def self.parse_name(name)
    return false unless name.is_a?(String)

    # First, split the name into an array
    parts = name.split

    # If any part is "and", then put together the two parts around it
    # For example, "Mr. and Mrs." or "Mickey and Minnie"
    parts.each_with_index do |part, i|
      if ["and", "&"].include?(part) and i > 0
        p3 = parts.delete_at(i+1)
        p2 = parts.at(i)
        p1 = parts.delete_at(i-1)
        parts[i-1] = [p1, p2, p3].join(" ")
      end
    end

    # Build a hash of the remaining parts
    hash = {
      :suffix => (s = parts.pop unless parts.last !~ /(\w+\.|[IVXLM]+|[A-Z]+)$/),
      :last_name  => (l = parts.pop),
      :prefix => (p = parts.shift unless parts[0] !~ /^\w+\./),
      :first_name => (f = parts.shift),
      :middle_name => (m = parts.join(" "))
    }

    #Reverse name if "," was used in Last, First notation.
    if hash[:first_name] =~ /,$/
      hash[:first_name] = hash[:last_name]
      hash[:last_name] = $` # everything before the match
    end

    return hash
  end

end
