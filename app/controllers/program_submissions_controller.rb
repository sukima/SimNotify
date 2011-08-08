class ProgramSubmissionsController < ApplicationController
  # Allow public access to :new and :create
  before_filter :require_admin, :except => [ :new, :create ]

  def index
    @program_submissions = ProgramSubmission.all

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @program_submissions }
    end
  end

  def new
    @program_submission = ProgramSubmission.new

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @program_submission }
    end
  end

  def create
    @program_submission = ProgramSubmission.new(params[:program_submission])

    respond_to do |wants|
      if @program_submission.save
        #flash[:notice] = 'Your submission has been sent. Thank You.'
        wants.html { redirect_to(@program_submission) }
        wants.xml  { render :xml => @program_submission, :status => :created, :location => @program_submission }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @program_submission.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @program_submission = ProgramSubmission.find(params[:id])

    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @program_submission }
    end
  end

  def destroy
    @program_submission = ProgramSubmission.find(params[:id])
    @program_submission.destroy

    respond_to do |wants|
      wants.html { redirect_to(program_submissions_url) }
      wants.xml  { head :ok }
    end
  end
end
