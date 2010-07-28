class MainController < ApplicationController
  def index
    unless logged_in?
      redirect_to login_url
    end
    @events_in_queue = @current_instructor.events.find(:all, :conditions => { :submitted => false, :approved =>  false })
    @events_submitted = @current_instructor.events.find(:all, :conditions => { :submitted => true, :approved =>  false })
    @events_approved = @current_instructor.events.find(:all, :conditions => { :approved =>  true })
  end
end
