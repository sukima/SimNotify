class InstructorsController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :emails]
  before_filter :login_admin, :only => :index
  # We do not allow instructors to be destroyed; no :destroy action available.

  def index
    @instructors = Instructor.all
  end

  def show
    @instructor = Instructor.find(params[:id])
  
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @instructor }
    end
  end

  def new
    @instructor = Instructor.new
    @instructor.gui_theme = "base"
    current_instructor
  end
  
  def create
    @instructor = Instructor.new(params[:instructor])

    # When a user is created we can't allow them to self promote to admin.
    @instructor.admin = false unless is_admin?
    @instructor.notify_recipient = false unless is_admin?

    if @instructor.save
      ApplicationMailer.deliver_welcome_email(@instructor)
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
    unless @instructor == @current_instructor || login_admin
      return
    end
    
    # Prevent self promotion to admin.
    @instructor.admin = false unless is_admin?
    @instructor.notify_recipient = false unless is_admin?

    respond_to do |wants|
      if @instructor.update_attributes(params[:instructor])
        flash[:notice] = "Successfully updated #{(is_admin?) ? "#{@instructor.name}'s" : "your" } profile."
        wants.html { redirect_to(@instructor) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @instructor.errors, :status => :unprocessable_entity }
      end
    end
  end

  def emails
    if params[:term]
      @emails = Instructor.find(:all, :conditions =>
        ["name LIKE ? OR email LIKE ?", '%'+params[:term]+'%', '%'+params[:term]+'%'])
    else
      @emails = Instructor.all
    end
    @emails = @emails.map do |i|
      { :label => "#{i.name} <#{i.email}>", :value => i.email }
    end

    respond_to do |format|
      format.json { render :json => @emails.to_json }
      format.any { render :text => "Invalid format", :status => 406 }
    end
  end
end
