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
end
