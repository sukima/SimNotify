class ProgramsController < ApplicationController
  before_filter :login_required
  before_filter :login_admin, :except => [ :index, :show ]

  def index
    @programs = Program.all

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @programs }
    end
  end

  def show
    @program = Program.find(params[:id])

    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @program }
    end
  end

  def new
    @program = Program.new

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @program }
    end
  end

  def create
    @program = Program.new(params[:program])

    respond_to do |wants|
      if @program.save
        flash[:notice] = 'Program was successfully created.'
        wants.html { redirect_to(@program) }
        wants.xml  { render :xml => @program, :status => :created, :location => @program }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @program = Program.find(params[:id])
  end

  def update
    @program = Program.find(params[:id])

    respond_to do |wants|
      if @program.update_attributes(params[:program])
        flash[:notice] = 'Program was successfully updated.'
        wants.html { redirect_to(@program) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |wants|
      wants.html { redirect_to(programs_url) }
      wants.xml  { head :ok }
    end
  end
end
