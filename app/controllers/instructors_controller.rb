class InstructorsController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :emails]
  before_filter :login_admin, :only => [:index, :destroy]

  def index
    @instructors = Instructor.all
  end

  def new
    @instructor = Instructor.new
    current_instructor
  end
  
  def create
    @instructor = Instructor.new(params[:instructor])
    if @instructor.save
      flash[:notice] = "Thank you for signing up! You are now logged in."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
    @instructor = Instructor.find(params[:id])
    login_admin unless @instructor == @current_instructor
  end

  def update
    @instructor = Instructor.find(params[:id])
    login_admin unless @instructor == @current_instructor
    if @instructor.update_attributes(params[:instructor])
      flash[:notice] = "Successfully updated your profile."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @instructor = Instructor.find(params[:id])
    @instructor.destroy
    flash[:notice] = "Successfully destroyed instructor profile."
    redirect_to :action => 'show'
  end

  def emails
    @emails = Instructor.all.map { |i| i.email }

    respond_to do |format|
      format.js { render :json => @emails.to_json }
      format.any { render :text => "Invalid format", :status => 406 }
    end
  end
end
