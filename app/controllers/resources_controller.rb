class ResourcesController < ApplicationController
  before_filter :define_scope, :only => [:index]
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
  def commodity
    if CommodityType.aliases.keys.include?(params[:commodity])
      commodity = CommodityType.aliases[params[:commodity]]
    else
      commodity = params[:commodity]
    end
    if params[:year]
      year = params[:year].to_i
      year_end = year+1
    else
      year = 1995
      year_end = 2010
    end
    @grades = Array.new
    options = Hash.new
    while year < year_end
      grade = IdentifiedResource.new
      grade.year=year
	 
      grade.set_commodity(params[:commodity])
      grade.commodity_unit = CommodityType.find(grade.commodity).displayunit
      grade.grade_unit = CommodityType.find(grade.commodity).gradeunit
      grade.ore_unit = CommodityType.find(grade.commodity).oreunit
	 
      grade.commodity_factor = UnitCode.find(grade.commodity_unit).unitvalue
      grade.grade_factor = UnitCode.find(grade.grade_unit).unitvalue if grade.grade_unit
      grade.ore_factor = UnitCode.find(grade.ore_unit).unitvalue if  grade.ore_unit
      if params[:state] == "All"
        state = nil
      else
        state = params[:state]
      end
      resources = Resource.grade(commodity, year, {:state=>state,:eno=>params[:eno]})
      options["coal"]=params[:coal] if params[:coal]
      grade.set_resources(resources,options)
      # resources.each do |resource|
      #
      # grade.edr_commodity += get_resources(resource,'edr',options)[0]
      # grade.edr_ore += get_resources(resource,'edr',options)[1]
      # grade.dmp_commodity += get_resources(resource,'dmp',options)[0]
      # grade.dmp_ore += get_resources(resource,'dmp',options)[1]
      # grade.dms_commodity += get_resources(resource,'dms',options)[0]
      # grade.dms_ore += get_resources(resource,'dms',options)[1]
      # grade.ifr_commodity += get_resources(resource,'ifr',options)[0]
      # grade.ifr_ore += get_resources(resource,'ifr',options)[1]
      # grade.recorddate=resource.recorddate
		
		
      # end
	  
	 
      @grades << grade
      year += 1
    end

	
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
