class EventsController < ApplicationController
  before_filter :login_required

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @event.instructor = @current_instructor
  end

  def create
    @event = Event.new(params[:event])
    @event.instructor = @current_instructor
    if @event.save
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
    @event.destroy
    flash[:notice] = "Successfully destroyed event."
    redirect_to events_url
  end

  def submit
    @event = Event.find(params[:id])
    if @event.instructor != @current_instructor && !is_admin?
      flash[:error] = "You do not have permission to do that"
      redirect_to root_url
    end
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
end
