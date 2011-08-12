class ProgramsController < ApplicationController
  before_filter :login_required
  before_filter :login_admin, :except => [ :index, :show ]

  def index # {{{1
    @programs = Program.all

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @programs }
    end
  end

  def show # {{{1
    @program = Program.find(params[:id])

    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @program }
    end
  end

  def new # {{{1
    @program = Program.new

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @program }
    end
  end

  def create # {{{1
    @program = Program.new(params[:program])
    @program.created_by = @current_instructor

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

  def edit # {{{1
    @program = Program.find(params[:id])
  end

  def update # {{{1
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

  def destroy # {{{1
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |wants|
      wants.html { redirect_to(programs_url) }
      wants.xml  { head :ok }
    end
  end

  # }}}1
end
# vim:set sw=2 ts=2 sts=2 et fdm=marker:
