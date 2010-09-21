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
    redirect_to root_url unless event_owned_or_admin_check(@event)
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
      return
    end
    render :action => 'new'
  end

  def edit
    @event = Event.find(params[:id])
    redirect_to root_url unless event_owned_or_admin_check(@event)
  end

  def update
    @event = Event.find(params[:id])
    if !event_owned_or_admin_check(@event)
      redirect_to root_url
      return
    else
      if params[:event][:submit_note]
        if @event.update_attributes({
            :submit_note => params[:event][:submit_note],
            :submitted => true
          })
          ApplicationMailer.deliver_submitted_email(@event)
          flash[:notice] = "Session has been submitted for approval. Thank you."
          redirect_to root_url
          return
        end
      elsif params[:event][:revoke_note]
        if @event.update_attributes({
            :revoke_note => params[:event][:revoke_note],
            :approved => false,
            :submitted => false
          })
          ApplicationMailer.deliver_revoked_email(@event)
          flash[:notice] = "Session has been revoked. Notification email has been sent."
          if is_admin?
            redirect_to events_path
          else
            redirect_to @event
          end
          return
        end
      elsif @event.update_attributes(params[:event])
        flash[:notice] = "Successfully updated session"
        redirect_to @event
        return
      end
    end
    render :action => 'edit'
  end

  def destroy
    @event = Event.find(params[:id])
    if event_owned_or_admin_check(@event)
      if @event.submitted? || @event.approved?
        flash[:error] = t(:cannot_destroy_event)
      else
        @event.destroy
        flash[:notice] = "Successfully deleted event."
      end
    end
    redirect_to events_url
  end

  def submit
    @event = Event.find(params[:id])
    redirect_to root_url unless event_owned_or_admin_check(@event)
  end

  def revoke
    @event = Event.find(params[:id])
    redirect_to root_url unless event_owned_or_admin_check(@event)
  end

  def approve
    if !is_admin?
      flash[:error] = "You do not have permission to do that"
      redirect_to root_url
      return
    end
    if params[:id]
      @event = Event.find(params[:id])
      @event.approved = true
      if @event.save
        flash[:notice] = "Successfully approved event"
      end
      redirect_to @event
      return
    end
    if params[:event_ids]
      Event.update_all ["approved=?", true], :id => params[:event_ids]
      flash[:notice] = "Sessions have been approved"
      redirect_to events_path
      return
    end
  end
end
