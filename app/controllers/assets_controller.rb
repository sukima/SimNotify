class AssetsController < ApplicationController
  before_filter :login_required
  before_filter :find_event

  def index
    # TODO: Allow selecting assets from list of past uploads.
    # if not @event.nil?
      @assets = @event.assets
    # elsif is_admin?
      # @assets = Asset.all
    # else
      # @assets = Asset.find(:all, :conditions => {:instructor => @current_instructor})
    # end

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
    assign_instructor

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @asset }
    end
  end

  def create
    @asset = Asset.new(params[:asset])
    assign_event
    assign_instructor

    respond_to do |wants|
      if @asset.save
        flash[:notice] = 'Asset was successfully uploaded.'
        wants.html do
          if params[:commit] == I18n.translate("formtastic.actions.add_more_assets")
            redirect_to new_event_asset_path(@event)
          elsif params[:commit] == I18n.translate("formtastic.actions.finish_assets")
            redirect_to root_url
          else
            redirect_to(@event)
          end
        end
        wants.xml  { render :xml => @asset, :status => :created, :location => @asset }
      else
        flash[:error] = 'There was a problem processing your file. Please try again.'
        wants.html { redirect_to new_event_asset_path(@event) }
        wants.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |wants|
      wants.html { redirect_to(event_path(@event)) }
      wants.xml  { head :ok }
    end
  end

  private
  def assign_event
    @asset.events = [ @event ] if !@event.blank?
  end

  def assign_instructor
    @asset.instructor = @current_instructor
  end

  def find_event
    @event = Event.find(params[:event_id]) if !params[:event_id].blank?
  end
end
