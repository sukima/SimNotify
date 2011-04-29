class MainController < ApplicationController
  before_filter :login_required, :except => [:autocomplete_map]

  def index
    @events_in_queue = Event.in_queue(@current_instructor)
    @events_submitted = Event.submitted(@current_instructor)
    @events_approved = Event.approved(@current_instructor)
    @events_needs_approval = Event.submitted(:all) if is_admin?
  end

  def help
    @is_help = true
    if params[:partial]
      render :partial => "help"
    end
  end

  def autocomplete_map
    @map = { :instructor_session_email => emails_instructors_path }
    if logged_in?
      @map[:event_location] = location_suggestions_path
      @map[:event_instructors] = emails_instructors_path
    end

    render :json => @map.to_json
  end
end
