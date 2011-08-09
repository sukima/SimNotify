module ProgramSubmissionsHelper
  def link_to_program_submission(title, program_submission)
    return link_to title, program_submission_path(program_submission)
  end
end
