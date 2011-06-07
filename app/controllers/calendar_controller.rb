class CalendarController < ApplicationController
  before_filter :login_required
  before_filter :login_admin, :only => :agenda
  helper :events

  def index
    @is_calendar = true
    # respond_to do |format|
      # format.html
    # end
  end

  def agenda
    @time_format = "%a, %B %d"
    today = Time.now

    @number_of_weeks = ( (params[:number_of_weeks].blank?) ? "3" : params[:number_of_weeks] ).to_i
    @weeks = [ ]
    for x in 1..@number_of_weeks do
      the_week = {
        :week_start => today.beginning_of_week + x.weeks,
        :week_end => today.end_of_week + x.weeks,
        :events => [ ]
      }
      conditions = { :start_time => (the_week[:week_start]..the_week[:week_end]) }
      the_week[:events] = Event.find(:all, :conditions => conditions) +
        SpecialEvent.find(:all, :conditions => conditions)
      the_week[:events].sort! { |a,b| a.start_time <=> b.start_time }

      @weeks << the_week
    end

    date_range_start = today.beginning_of_week
    date_range_end = (today.end_of_week) + (@number_of_weeks.weeks)
    @date_range = "#{date_range_start.strftime(@time_format)} - #{date_range_end.strftime(@time_format)}"

    render :layout => false
  end

  def events
    if !params[:start] || !params[:end]
      render :text => "Invalid parameters", :status => :not_acceptable
      return
    end

    start_time = Time.at(params[:start].to_i)
    end_time = Time.at(params[:end].to_i)
    conditions = { :start_time => (start_time..end_time) }

    if (is_admin?)
      @events = Event.find(:all, :conditions => conditions)
    else
      @events = @current_instructor.events.find(:all, :conditions => conditions)
    end

    @special_events = SpecialEvent.find(:all,
        :conditions => conditions.except(:submitted))

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

    render :json => json_events.to_json
  end

  private
  def build_json_event(e, opt={ :eventMethod => :event_path, :allDay => :live_in? })
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
