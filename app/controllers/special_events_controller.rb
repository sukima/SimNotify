class SpecialEventsController < ApplicationController
  before_filter :login_required

  def index
    @listing_mod = params[:mod]
    if @listing_mod == "all"
      @special_events = SpecialEvent.all
    elsif @listing_mod == "old"
      @special_events = SpecialEvent.find(:all, :conditions => ["start_time < ?", Time.now])
    else
      @special_events = SpecialEvent.find(:all, :conditions =>
        ["start_time >= ?", Time.now])
    end
  end

  def show
    @special_event = SpecialEvent.find(params[:id])
  end

  def new
    @special_event = SpecialEvent.new
    @special_event.instructor = @current_instructor
  end

  def create
    @special_event = SpecialEvent.new(params[:special_event])
    @special_event.instructor = @current_instructor
    if @special_event.save
      flash[:notice] = "Successfully created special event."
      redirect_to @special_event
    else
      render :action => 'new'
    end
  end

  def edit
    @special_event = SpecialEvent.find(params[:id])
    redirect_to root_url unless event_owned_or_admin_check(@special_event)
  end

  def update
    @special_event = SpecialEvent.find(params[:id])
    if event_owned_or_admin_check(@special_event)
      if @special_event.update_attributes(params[:event])
        flash[:notice] = "Successfully updated special event"
        redirect_to @special_event
        return
      end
      render :action => 'edit'
    else
      redirect_to root_url
    end
  end

  def destroy
    @special_event = SpecialEvent.find(params[:id])
    if event_owned_or_admin_check(@special_event)
      @special_event.destroy
      flash[:notice] = "Successfully deleted special event."
      redirect_to special_events_url
    else
      redirect_to root_url
    end
  end
end
