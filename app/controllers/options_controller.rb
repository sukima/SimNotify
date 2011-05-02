class OptionsController < ApplicationController
  before_filter :login_required, :login_admin

  def index
    @options = load_options
  
    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @options }
    end
  end

  def update
    @option = Option.find(params[:id])
  
    respond_to do |wants|
      if @option.update_attributes(params[:option])
        flash[:notice] = "Option #{@option.name} was successfully updated."
        wants.html { redirect_to(options_path) }
        wants.xml  { head :ok }
      else
        wants.html { redirect_to(options_path) }
        wants.xml  { render :xml => @option.errors, :status => :unprocessable_entity }
      end
    end
  end
end
