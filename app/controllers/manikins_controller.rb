class ManikinsController < ApplicationController
  before_filter :login_required
  before_filter :login_admin

  def index
    @manikins = Manikin.all
  end
  
  def show
    @manikin = Manikin.find(params[:id])
  end
  
  def new
    @manikin = Manikin.new
  end
  
  def create
    @manikin = Manikin.new(params[:manikin])
    if @manikin.save
      flash[:notice] = "Successfully created manikin."
      redirect_to @manikin
    else
      render :action => 'new'
    end
  end
  
  def edit
    @manikin = Manikin.find(params[:id])
  end
  
  def update
    @manikin = Manikin.find(params[:id])
    if @manikin.update_attributes(params[:manikin])
      flash[:notice] = "Successfully updated manikin."
      redirect_to @manikin
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @manikin = Manikin.find(params[:id])
    @manikin.destroy
    flash[:notice] = "Successfully destroyed manikin."
    redirect_to manikins_url
  end
end
