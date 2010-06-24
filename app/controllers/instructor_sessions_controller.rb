class InstructorSessionsController < ApplicationController
  def new
    @instructor_session = InstructorSession.new
  end
  
  def create
    @instructor_session = InstructorSession.new(params[:instructor_session])
    if @instructor_session.save
      flash[:notice] = "Logged in successfully."
      redirect_to_target_or_default(root_url)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @instructor_session = InstructorSession.find
    @instructor_session.destroy
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
end
