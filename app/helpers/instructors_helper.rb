module InstructorsHelper
  def roles_for(instructor)
    roles = [ ]
    roles << "Administrator" if instructor.admin?
    roles << "Technician" if instructor.is_tech?
    return "" if roles.empty?
    "<p><strong>Roles:</strong> #{h roles.to_sentence}</p>"
  end

  def inactive_notification_for(instructor)
    inactive_style = (instructor.active?) ? "display:none" : ""
    content_tag :div, {:id => "instructor_inactive_warning", :class => "warning", :style => inactive_style } do
      "This instructor is locked! He or She <strong>can not</strong> log into #{APP_CONFIG[:application_name]}."
    end
  end
end
