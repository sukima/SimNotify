module InstructorsHelper
  def roles_for(instructor)
    roles = [ ]
    roles << "Administrator" if instructor.admin?
    roles << "Technician" if instructor.is_tech?
    return "" if roles.empty?
    "<p><strong>Roles:</strong> #{h roles.to_sentence}</p>"
  end
end
