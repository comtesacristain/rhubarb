class ResourcesController < ApplicationController
  before_filter :define_scope, :only => [:index]
  before_filter :require_ozmin_user
  # GET /zones
  # GET /zones.xml
  def index

    unless params[:format]
      @scope = @scope.paginate :page => params[:page] , :order => 'recorddate DESC' if !params[:format]
	  else
      @scope = @scope.all
	  end

    @resources = @scope
    respond_to do |format|

      format.html # index.html.erb
      format.xml  { render :xml => @resources }
    end
  end

  def show
    resource = Resource
    unless (current_user && current_user.ozmin?)
      resource = resource.public
    end
    @resource = resource.find(params[:id])
  end

  def aimr
    if !params[:year]
      params[:year] = Date.today.year - 1
    end
    respond_to do |format|
      format.html # aimr.html.erb
    end
  end
  
  def state 
    if !params[:year]
      params[:year] = Date.today.year - 1
    end
    if !params[:commodity]
      params[:commodity] = 'Au'
    end
    respond_to do |format|
      format.html # mineral.html.erb
    end
  end
  
  def year
    if !params[:state]
      params[:state] = 'Australia'
    end
    if !params[:commodity]
      params[:commodity] = 'Au'
    end
    respond_to do |format|
      format.html # mineral.html.erb
    end
  end
  
  # GET /zones/1
  # GET /zones/1.xml
  def identified
    if CommodityType.aliases.keys.include?(params[:commodity])
      commodity = CommodityType.aliases[params[:commodity]]
    else
      commodity = params[:commodity]
    end

    if params[:year]
      year = params[:year].to_i
    else
      year=Date.today.year.to_i
    end

    scope = Resource.mineral(commodity).year(year).nonzero

    if params[:recoverability] == 'recoverable'
      scope=scope.recoverable
    elsif params[:recoverability] == 'insitu'
      scope=scope.insitu
    end

    if !params[:state].blank? || !params[:status].blank?
      scope = scope.includes(:deposit_status)
      scope=scope.merge(DepositStatus.state(params[:state])) if !params[:state].blank?
      scope=scope.merge(DepositStatus.status(params[:status])) if !params[:status].blank?
    end
   
    resources = scope.all

    @identified_resources = IdentifiedResourceSet.new(resources)

    respond_to do |format|
      format.json #{ render :json => @grades.to_json }# grade.html.erb
    end
  end

  private
  def define_scope
    scope = Resource
    unless (current_user && current_user.ozmin?)
      scope = scope.public
    end
    @scope = scope
  end
end
