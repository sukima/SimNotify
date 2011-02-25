class AssetsController < ApplicationController
  before_filter :login_required
  before_filter :find_event

  def index
    @assets = Asset.all

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @assets }
    end
  end

  def show
    @asset = Asset.find(params[:id])

    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @asset }
    end
  end

  def new
    @asset = Asset.new
    assign_event

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @asset }
    end
  end

  def create
    @asset = Asset.new(params[:asset])
    assign_event

    respond_to do |wants|
      if @asset.save
        flash[:notice] = 'Asset was successfully uploaded.'
        wants.html { redirect_to(@asset) }
        wants.xml  { render :xml => @asset, :status => :created, :location => @asset }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |wants|
      wants.html { redirect_to(assets_url) }
      wants.xml  { head :ok }
    end
  end

  private
  def assign_event
    @asset.event = @event if !@event.blank?
  end

  def find_event
    @event = Event.find(params[:event_id]) if !params[:event_id].blank?
  end
end
