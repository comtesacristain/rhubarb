class DepositsController < ApplicationController
  before_filter :define_scope, :only => [:index, :mineral_system, :map, :resources, :quality_check, :atlas]
  before_filter :require_ozmin_user, :only => [:resources, :quality_check]

  def index
    unless params[:format]
      @scope = @scope.page(params[:page]).order('entityid ASC')
	  else
      @scope = @scope.all
	  end
	  @deposits = @scope

    respond_to do |format|

      format.html # index.html.erb
      format.xml  { render :xml => @deposits }
      format.kml 
      #format.gsml #{ render :action => 'index_gsml', :layout => false }
      format.csv
    end
  end

  def quality_check

    unless params[:format]
      @scope = @scope.paginate :page => params[:page] , :order => 'entityid ASC' if !params[:format]
	  else
      @scope = @scope.all
	  end
	  @deposits = @scope

    respond_to do |format|

      format.html # index.html.erb
      format.xml  { render :xml => @deposits }
      format.kml { render :action => 'index_kml', :layout => false }
      format.xls if params[:format] == 'xls'
    end
  end

  def mineral_system
    if !params[:format]
      @scope = @scope.paginate :page => params[:page] , :order => 'entityid ASC' if !params[:format]
    else
      @scope = @scope.all
	  end
	  @deposits = @scope

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => Deposit.all }
      format.kml { render :action => 'mineral_system_kml', :layout => false }
      format.csv
    end
  end

  def resources
    if !params[:year]
      params[:year] = 2010
    end
    if !params[:type]
      params[:type] = ['ore','commodity','grade']
    end
    if !params[:resource]
      params[:resource] = ['total']
    end
    @date = '31-DEC-'+params[:year].to_s
    #@scope = @scope.includes(:resources => :resource_grades)
    if params[:commodity] and params[:commodity] != "All"
      if CommodityType.aliases.keys.include?(params[:commodity])
        @commodity = CommodityType.aliases[params[:commodity]]
      else
        @commodity = params[:commodity]
      end
      #@scope = @scope.merge(Resource.mineral(@commodity).year(@date))
	  end

    #@scope = @scope.merge(ResourceGrade.mineral(params[:commodity])) if params[:commodity] and params[:commodity] != "All"
    unless params[:format]
  		@scope = @scope.paginate :page => params[:page] , :order => 'a.entities.entityid ASC'
    else
      @scope = @scope.all
    end
	  @deposits = @scope #Deposit.mineral('Au').includes(:zones => {:resources => :resource_grades}).merge(Resource.year('31-DEC-2010')).merge(ResourceGrade.mineral('Au'))


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => Deposit.all }
  	  format.csv
    end
  end

  def map
	  @scope = @scope.all
	  @deposits = @scope
	  respond_to do |format|
      format.html # map.html.erb
      format.xml  { render :xml => @deposits }
    end
  end

  def atlas
    @deposits = Deposit.status('operating mine').major.public

    respond_to do |format|
      format.kml { render :action => 'atlas_kml', :layout => false }
    end
  end

  # GET /deposits/1
  # GET /deposits/1.xml
  def show
    deposit = Deposit
    unless (current_user && current_user.ozmin?)
      deposit = deposit.public
    end
    @deposit = deposit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deposit }
      format.kml
    end
  end

  private
  def define_scope
	  scope =  if params[:province_id]
      Province.find(params[:province_id]).deposits
    else
      Deposit
    end
    
	  if params[:commodity] and params[:commodity] != "All"
      if CommodityType.aliases.keys.include?(params[:commodity])
        commodity = CommodityType.aliases[params[:commodity]]
      else
        commodity = params[:commodity]
      end
      unless (current_user && current_user.ozmin?)
        scope = scope.mineral(commodity).merge(Commodity.public)
      else
        scope = scope.mineral(commodity)
      end
	  end
    #
	  scope = scope.state(params[:state]) if params[:state] and params[:state] != "All"
	  scope = scope.status(params[:status]) if params[:status] and params[:status] != "All"
	  scope = scope.bounds(eval("["+params[:bbox]+"]")) if params[:bbox]
    scope = scope.by_name(params[:name]) unless params[:name].nil?
	  @scope = scope
	end


end
