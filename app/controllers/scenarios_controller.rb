class ScenariosController < ApplicationController
  before_filter :login_required
  before_filter :login_admin, :only => :index

  def index
    @scenarios = Scenario.all
  end
  
  def show
    @scenario = Scenario.find(params[:id])
    redirect_to root_url unless event_owned_or_admin_check(@scenario.event)
  end
  
  def new
    if !params[:event_id]
      throw t(:missing_parameters)
    end
    @scenario = Scenario.new
    @scenario.event_id = params[:event_id]
  end
  
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.event = Event.find(params[:scenario][:event_id])
    if event_owned_or_admin_check(@scenario.event)
      if @scenario.save
        flash[:notice] = "Successfully created scenario."
        redirect_to @scenario
      else
        render :action => 'new'
      end
    else
      redirect_to root_url
    end
  end
  
  def edit
    @scenario = Scenario.find(params[:id])
    redirect_to root_url unless event_owned_or_admin_check(@scenario.event)
  end
  
  def update
    @scenario = Scenario.find(params[:id])
    if event_owned_or_admin_check(@scenario.event)
      if @scenario.update_attributes(params[:scenario])
        flash[:notice] = "Successfully updated scenario."
        redirect_to @scenario
      else
        render :action => 'edit'
      end
    else
      redirect_to root_url
    end
  end
  
  def destroy
    @scenario = Scenario.find(params[:id])
    if event_owned_or_admin_check(@scenario.event)
      @scenario.destroy
      flash[:notice] = "Successfully destroyed scenario."
      redirect_to scenarios_url
    else
      redirect_to root_url
    end
  end
end
