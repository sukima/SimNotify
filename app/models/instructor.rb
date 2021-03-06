class Instructor < ActiveRecord::Base
  include Gravtastic

  acts_as_authentic
  gravtastic :rating => 'PG', :default => Option.find_option_for("gravatar_default")

  has_many :events, :dependent => :nullify
  has_many :assets, :dependent => :nullify
  belongs_to :facility

  before_destroy :destroyable?

  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :name
  validates_each :name do |record, attr, value|
    _name_hash = self.parse_name(value)
    if _name_hash != false
      record.errors.add attr, I18n.translate(:missing_first_last_names) if
        ( _name_hash[:first_name].nil? || _name_hash[:last_name].nil? )
    end
  end

  validates_format_of :phone, :with => /^$|^\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$/,
    :message => I18n.translate(:bad_phone_number)

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

    #Covert to nill if empty string found
    hash[:middle_name] = nil if hash[:middle_name].empty?

    #Reverse name if "," was used in Last, First notation.
    if hash[:first_name] =~ /,$/
      hash[:first_name] = hash[:last_name]
      hash[:last_name] = $` # everything before the match
    end

    return hash
  end

  # <b>DEPRECATED:</b> Please use <tt>Option model ("system_email_recipients")</tt> instead.
  def self.notify_emails()
    warn "`notify_emails()` is deprecated. Use the Option model ('system_email_recipients') instead."
    ApplicationMailer.recipients_from_options
  end

  def destroyable?
    # TODO: This should check for event dependencies and allow them to be moved/detroyed first.
    false
  end

  def self.technicians
    self.find(:all, :conditions => { :is_tech => true })
  end
end
