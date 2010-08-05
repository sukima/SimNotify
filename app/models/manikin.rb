class Manikin < ActiveRecord::Base
  belongs_to :manikin_req_type

  validates_existence_of :manikin_req_type, :message => "must be assigned"
  validates_presence_of :name, :sim_type
  validates_uniqueness_of :name

  def name_and_type
    "#{name} (#{sim_type})"
  end
end
