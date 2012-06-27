class MajorProjectsController < ApplicationController
  before_filter :define_scope, :only => [:index]
  #before_filter :require_user
  # GET /major_projects
  # GET /major_projects.xml
  def index

    unless params[:format]
      @scope = @scope.paginate :page => params[:page] , :order => 'entityid ASC' unless params[:format]
	  else
      @scope = @scope.all
	  end
    @major_projects=@scope


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @major_projects }
      format.csv
      format.kml 
    end
  end

  # GET /major_projects/1
  # GET /major_projects/1.xml
  def show
    @major_project = MajorProject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @major_project }
    end
  end

  def define_scope
	  scope = MajorProject
    scope = scope.by_name(params[:name]) unless params[:name].nil?
    scope = scope.bbox(eval("["+params[:bbox]+"]")) if params[:bbox]
    scope = scope.public if params[:public]
	  @scope = scope
	end
end