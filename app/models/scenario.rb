class Scenario < ActiveRecord::Base
  belongs_to :event
  belongs_to :manikin_req_type
  belongs_to :manikin

  def flags_as_strings
    flags = Array.new
    flags << "Staff Support" if staff_support
    flags << "Moulage" if moulage
    flags << "Video Debriefing" if video
    flags << "Mobile Cart" if mobile
    return flags
  end
end
