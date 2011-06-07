class NotificationsController < ApplicationController
  before_filter :login_required, :login_admin

  def index
    @events = get_upcomming_events

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @events }
    end
  end

  def send_notice
    @event = Event.find(params[:event_id])

    @event.send_notification

    flash[:notice] = "Notification sent."
    redirect_to :action => 'index'
  end

  def batch_send
    ApplicationMailer.send_upcoming_notifications

    flash[:notice] = "Email notifications sent."
    redirect_to :action => 'index'
  end

  private
  def get_upcomming_events(days=nil)
    if days.nil?
      o = Option.find_option_for('days_to_send_event_notifications')
      days = o.value
    end
    return Event.find_upcomming_approved(days)
  end
end
