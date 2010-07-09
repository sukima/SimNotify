class ScenariosController < ApplicationController
  def index
    @scenarios = Scenario.all
  end
  
  def show
    @scenario = Scenario.find(params[:id])
  end
  
  def new
    @scenario = Scenario.new
    @scenario.event_id = params[:event_id]
  end
  
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.event = Event.find(params[:scenario][:event_id])
    if @scenario.save
      flash[:notice] = "Successfully created scenario."
      redirect_to @scenario
    else
      render :action => 'new'
    end
  end
  
  def edit
    @scenario = Scenario.find(params[:id])
  end
  
  def update
    @scenario = Scenario.find(params[:id])
    if @scenario.update_attributes(params[:scenario])
      flash[:notice] = "Successfully updated scenario."
      redirect_to @scenario
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @scenario = Scenario.find(params[:id])
    @scenario.destroy
    flash[:notice] = "Successfully destroyed scenario."
    redirect_to scenarios_url
  end
end
