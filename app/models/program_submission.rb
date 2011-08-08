# Attributes:
#   name       => string
#   job_title  => string
#   department => string
#   phone      => string
#   email      => string
#   summery    => text
#   outcome    => text
#   supervisor_notified => boolean
#   proximity  => string
#   additional_info => text
class ProgramSubmission < ActiveRecord::Base
  validates_presence_of :name, :email, :department, :summery
  validates_format_of :phone, :with => /^$|^\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$/,
    :message => I18n.translate(:bad_phone_number)
end
