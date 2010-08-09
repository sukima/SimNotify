class CalendarController < ApplicationController
  before_filter :login_required
  before_filter :login_admin

  def index
    respond_to do |format|
      format.html
    end
  end

  def events
    if params[:start] && params[:end]
      start_time = Time.at(params[:start].to_i)
      end_time = Time.at(params[:end].to_i)
      @events = Event.find(
        :all,
        :conditions => [
          "start_time >= ? AND end_time <= ?",
          start_time, end_time ]
      )
      json_events = []
      @events.each do |e|
        json_event = {
          :title => e.title,
          :start => e.start_time,
          :end => e.end_time,
          :url => event_path(e)
        }
        json_events << json_event
      end
    else
      render :text => "Invalid parameters", :status => 406
      return
    end

    respond_to do |format|
      format.js { render :json => json_events.to_json }
      format.any { render :text => "Invalid format", :status => 406 }
    end
  end
end
