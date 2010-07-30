class MainController < ApplicationController
  def index
    unless logged_in?
      redirect_to login_url
      return
    end
    @events_in_queue = Event.in_queue(@current_instructor)
    @events_submitted = Event.submitted(@current_instructor)
    @events_approved = Event.approved(@current_instructor)
  end
end
