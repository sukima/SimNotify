class FacilitiesController < ApplicationController
  before_filter :login_required
  before_filter :login_admin

  def index
    @facilities = Facility.all

    respond_to do |wants|
      wants.html # index.html.haml
      wants.xml  { render :xml => @facilities }
    end
  end

  def new
    @facility = Facility.new

    respond_to do |wants|
      wants.html # new.html.haml
      wants.xml  { render :xml => @facility }
    end
  end

  def create
    @facility = Facility.new(params[:facility])

    respond_to do |wants|
      if @facility.save
        flash[:notice] = 'Facility was successfully created.'
        wants.html { redirect_to(facilities_url) }
        wants.xml  { render :xml => @facility, :status => :created, :location => @facility }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @facility.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @facility = Facility.find(params[:id])
  end

  def update
    @facility = Facility.find(params[:id])

    respond_to do |wants|
      if @facility.update_attributes(params[:facility])
        flash[:notice] = 'Facility was successfully updated.'
        wants.html { redirect_to(facilities_url) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @facility.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @facility = Facility.find(params[:id])
    @facility.destroy

    respond_to do |wants|
      wants.html { redirect_to(facilities_url) }
      wants.xml  { head :ok }
    end
  end
end
