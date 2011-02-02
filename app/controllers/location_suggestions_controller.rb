class LocationSuggestionsController < ApplicationController
  before_filter :login_required
  before_filter :login_admin, :except => :index

  def index
    @location_suggestions = LocationSuggestion.all

    respond_to do |format|
      format.html { login_admin }
      format.json { render :json => @location_suggestions.map(&:location) }
    end
  end

  def show
    redirect_to :action => 'index'
  end

  def new
    @location_suggestion = LocationSuggestion.new
  end

  def create
    @location_suggestion = LocationSuggestion.new(params[:location_suggestion])
    if @location_suggestion.save
      flash[:notice] = "Successfully created location suggestion."
      redirect_to @location_suggestion
    else
      render :action => 'new'
    end
  end

  def edit
    @location_suggestion = LocationSuggestion.find(params[:id])
  end

  def update
    @location_suggestion = LocationSuggestion.find(params[:id])
    if @location_suggestion.update_attributes(params[:location_suggestion])
      flash[:notice] = "Successfully updated location suggestion."
      redirect_to @location_suggestion
    else
      render :action => 'edit'
    end
  end

  def destroy
    @location_suggestion = LocationSuggestion.find(params[:id])
    @location_suggestion.destroy
    flash[:notice] = "Successfully deleted location suggestion."
    redirect_to location_suggestions_url
  end
end
