class MainController < ApplicationController
  before_filter :login_required, :only => [:help]

  def index
    unless logged_in?
      redirect_to login_url
      return
    end
    @events_in_queue = Event.in_queue(@current_instructor)
    @events_submitted = Event.submitted(@current_instructor)
    @events_approved = Event.approved(@current_instructor)
  end

  def help
    @is_help = true
    if params[:partial]
      render :partial => "help"
    end
  end

  def autocomplete_map
    @map = {
      :instructor_session_email => emails_instructors_path,
      :event_location => location_suggestions_path,
      :event_instructors => emails_instructors_path
    }

    respond_to do |format|
      format.json { render :json => @map.to_json }
      format.any { render :text => "Invalid format", :status => 406 }
    end
  end
end
