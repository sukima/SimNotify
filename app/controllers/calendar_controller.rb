class CalendarController < ApplicationController
  before_filter :login_required
  before_filter :login_admin, :only => :agenda
  helper :events

  def index
    @is_calendar = true
    @facilities = Facility.find(:all)
    @facility_preferences = session[:calendar_facilities_pref] || :all
  end

  def save_preferences
    if params[:facilities].kind_of? Array
      session[:calendar_facilities_pref] = params[:facilities].collect do |f|
        f_id = f.slice(/\bfacility=([0-9]+|special)/,1)
        if f_id.nil? && f.match(/^([0-9]+|special)$/)
          f_id = f
        end # remains nil if not matching above pattern.
        f_id
      end
      render :text => "Preferences saved", :status => :ok
    else
      render :text => "Invalid parameter format", :status => :not_acceptable
    end
  end

  def tech_schedule
    @week_index = params[:week_index]
    @week_index ||= "0"
    @tech = Instructor.find(params[:tech_id])
    @technicians = Instructor.technicians

    i = @week_index.to_i
    @start_of_week = Time.now.beginning_of_week + i.weeks
    @end_of_week = Time.now.end_of_week + i.weeks
    @events = Event.find_by_technician(@tech, {
      :start_time => @start_of_week,
      :end_time => @end_of_week
    })
    @tech_id = @tech.id
  end

  def agenda
    @time_format = "%a, %B %d"
    today = Time.now

    @tech_id = params[:tech] || "all"
    @tech = Instructor.find(@tech_id)
    @number_of_weeks = ( (params[:number_of_weeks].blank?) ? "3" : params[:number_of_weeks] ).to_i
    @weeks = [ ]
    for x in 0..@number_of_weeks-1 do
      the_week = {
        :week_start => today.beginning_of_week + x.weeks,
        :week_end => today.end_of_week + x.weeks,
        :events => [ ]
      }
      conditions = { :start_time => (the_week[:week_start]..the_week[:week_end]) }
      the_week[:events] = SpecialEvent.find(:all, :conditions => conditions)

      conditions[:technician_id] = @tech unless @tech.blank? || @tech.downcase == "all"
      the_week[:events] += Event.find(:all, :conditions => conditions)

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

    if (params[:facility])
      f = params[:facility].downcase
    else
      f = "all"
    end

    start_time = Time.at(params[:start].to_i)
    end_time = Time.at(params[:end].to_i)
    conditions = { :start_time => (start_time..end_time) }

    if (f == "all" || f == "special")
      @special_events = SpecialEvent.find(:all, :conditions => conditions)
    else
      @special_events = [ ]
    end

    if (f != "special")
      if (f != "all")
        conditions[:facility_id] = f.to_i
      end
      @events = Event.find(:all, :conditions => conditions) if @events.nil?
    else
      @events = [ ]
    end

    respond_to do |wants|
      wants.json
    end
  end
end
