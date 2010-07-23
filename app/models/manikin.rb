class Manikin < ActiveRecord::Base
  belongs_to :manikin_req_type

  def name_and_type
    "#{name} (#{sim_type})"
  end
end
