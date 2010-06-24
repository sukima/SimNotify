class InstructorsController < ApplicationController
  def new
    @instructor = Instructor.new
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
end
