class CalendarController < ApplicationController
  before_filter :login_required
  before_filter :login_admin

  def index
    respond_to do |format|
      format.html
    end
  end
end
