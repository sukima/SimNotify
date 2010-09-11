class EventsController < ApplicationController
  before_filter :login_required

  def index
    @listing_mod = params[:mod]
    if is_admin?
      if @listing_mod == "all"
        @events = Event.all
      elsif @listing_mod == "old"
        @events = Event.find(:all, :conditions => ["start_time < ?", Time.now])
      else
        @events = Event.find(:all, :conditions =>
          ["start_time >= ? AND (submitted = ? OR approved = ?)",
          Time.now, true, true])
      end
    else
      @events = @current_instructor.events
    end
  end

  def show
    @event = Event.find(params[:id])
    event_owned_or_admin_check
  end

  def new
    @event = Event.new
    @event.instructor = @current_instructor
  end

  def create
    @event = Event.new(params[:event])
    @event.instructor = @current_instructor
    if @event.save
      if @current_instructor.new_user?
        @current_instructor.new_user = false
        @current_instructor.save
      end
      flash[:notice] = "Successfully created event."
      redirect_to @event
    else
      render :action => 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    event_owned_or_admin_check
    if params[:event] && params[:event][:submit_note] &&
      @event.update_attributes({
        :submit_note => params[:event][:submit_note],
        :submitted => true
      })
      ApplicationMailer.deliver_submitted_email(@event)
      flash[:notice] = "Session has been submitted for approval. Thank you."
      redirect_to root_url
    elsif @event.update_attributes(params[:event])
      flash[:notice] = "Successfully updated session"
      redirect_to @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    event_owned_or_admin_check
    @event.destroy
    flash[:notice] = "Successfully destroyed event."
    redirect_to events_url
  end

  def submit
    @event = Event.find(params[:id])
    event_owned_or_admin_check
  end

  def revoke
    @event = Event.find(params[:id])
    event_owned_or_admin_check
    @event.approved = @event.submitted = false
    if @event.save
      flash[:notice] = "Successfully revoked event"
    end
    redirect_to @event
  end

  def approve
    if !is_admin?
      flash[:error] = "You do not have permission to do that"
      redirect_to root_url
      return
    end
    @event = Event.find(params[:id])
    @event.approved = true
    if @event.save
      flash[:notice] = "Successfully approved event"
    end
    redirect_to @event
  end

  private
  def event_owned_or_admin_check
    if @event.instructor != @current_instructor && !is_admin?
      flash[:error] = "You do not have permission to do that"
      redirect_to root_url
    end
  end
end
