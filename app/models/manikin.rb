class Manikin < ActiveRecord::Base
  def name_and_type
    "#{name} (#{sim_type})"
  end
end
