class CalendarController < ApplicationController
  before_filter :login_required

  def index
    @is_calendar = true
    respond_to do |format|
      format.html
    end
  end

  def events
    if params[:start] && params[:end]
      start_time = Time.at(params[:start].to_i)
      end_time = Time.at(params[:end].to_i)
      conditions = { :start_time => (start_time .. end_time), :submitted => true }
      if (is_admin?)
        @events = Event.find(:all, :conditions => conditions)
      else
        @events = @current_instructor.events.find(:all, :conditions => conditions)
      end
      json_events = []
      @events.each do |e|
        json_event = {
          :title => e.title, # add submitted specials
          :start => e.start_time,
          :end => e.end_time,
          :url => event_path(e),
          :allDay => e.live_in?
        }
        className = e.status_as_class
        json_event[:className] = className unless className.nil?
        json_events << json_event
      end
    else
      render :text => "Invalid parameters", :status => 406
      return
    end

    respond_to do |format|
      format.json { render :json => json_events.to_json }
      format.any { render :text => "Invalid format", :status => 406 }
    end
  end
end
