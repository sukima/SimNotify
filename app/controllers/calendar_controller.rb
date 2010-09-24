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

      @special_events = SpecialEvent.find(:all,
          :conditions => conditions.except(:submitted)).

      json_events = [ ]


      @events.each do |e|
        json_events << build_json_event(e)
      end

      @special_events.each do |e|
        json_events << build_json_event(e, {
          :eventMethod => :special_event_path,
          :allDay => :all_day?
        })
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

  private
  def build_json_event(e, opt={ :eventMethod => event_path, :allDay => :live_in? })
      json_event = {
        :title => e.title, # add submitted specials
        :start => e.start_time.to_i,
        :end => e.end_time.to_i,
        :url => send(opt[:eventMethod], e),
        :allDay => e.send(opt[:allDay])
      }
      className = e.status_as_class
      json_event[:className] = className unless className.nil?
      return json_event
  end
end
