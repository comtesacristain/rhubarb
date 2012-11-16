class DepositsController < ApplicationController
  before_filter :define_scope, :only => [:index, :mineral_system, :map, :resources, :quality_check, :atlas, :jorc]
  before_filter :define_year, :only => [:resources, :jorc]
  before_filter :require_ozmin_user, :only => [:resources, :quality_check]
  before_filter :filename_generator

  def index
    if params[:year].blank?
      params[:year] = Date.today.year - 1 
    end
    
    unless params[:format]
      @scope = @scope.page(params[:page]).order('entityid ASC')
	  else
      @scope = @scope.all
	  end
	  @deposits = @scope

    respond_to do |format|

      format.html # index.html.erb
      format.xml  { render :xml => @deposits }
      format.kml {response.headers['Content-Disposition'] = "attachment; filename=\"#{@filename}.kml\""}
      format.csv {response.headers['Content-Disposition'] = "attachment; filename=\"#{@filename}.csv\""}
	  #format.gsml #{ render :action => 'index_gsml', :layout => false }
    end
  end

  def quality_check
	  @deposits = @scope.all
    respond_to do |format|
      format.xls {response.headers['Content-Disposition'] = "attachment; filename=\"#{@filename}.xls\""}
    end
  end

  def mineral_system
	  @deposits = @scope.all
    respond_to do |format|
      format.csv {response.headers['Content-Disposition'] = "attachment; filename=\"#{@filename}.csv\""}
    end
  end

  def resources
    
    # if !params[:type]
      # params[:type] = ['ore','commodity','grade']
    # end
    # if !params[:resource]
      # params[:resource] = ['total']
    # end
    if params[:commodity] and params[:commodity] != "All"
      if CommodityType.aliases.keys.include?(params[:commodity])
        @commodity = CommodityType.aliases[params[:commodity]]
      else
        @commodity = params[:commodity]
      end
 	  end

    unless params[:format]
      @scope = @scope.page(params[:page]).order('entityid ASC')
    else
      @scope = @scope.all
    end
	  @deposits = @scope


    respond_to do |format|
  	  format.csv {response.headers['Content-Disposition'] = "attachment; filename=\"#{@filename}.csv\""}
    end
  end

  def jorc
    if params[:commodity] and params[:commodity] != "All"
      if CommodityType.aliases.keys.include?(params[:commodity])
        @commodity = CommodityType.aliases[params[:commodity]]
      else
        @commodity = params[:commodity]
      end

	  end
    @deposits=@scope
    
    respond_to do |format|
  	  format.csv {response.headers['Content-Disposition'] = "attachment; filename=\"#{@filename}.csv\""}
    end
  end
 
  #TODO Fix to show deposits by commodity. 
  def map
	  @scope = @scope.all
	  @deposits = @scope
	  respond_to do |format|
      format.html # map.html.erb
    end
  end

  def atlas
    @deposits = Deposit.status('operating mine').major.public
    respond_to do |format|
      format.kml
    end
  end

  # GET /deposits/1
  # GET /deposits/1.xml
  def show
    deposit = Deposit
    unless (current_user) # && current_user.ozmin?)
      deposit = deposit.public
    end
    @deposit = deposit.find(params[:id].to_i)
    @resources = @deposit.resources.recent.all
    @weblinks = @deposit.weblinks

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
    
    unless (current_user ) #&& current_user.ozmin?
      scope = scope.public
    end
    
    unless params[:commodity].blank?
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
	  scope = scope.state(params[:state]) unless params[:state].blank?
	  scope = scope.status(params[:status]) unless params[:status].blank?
	  scope = scope.bounds(eval("["+params[:bbox]+"]")) unless params[:bbox].blank?
	  scope = scope.by_name(params[:name]) unless params[:name].blank?
	  @scope = scope
	end

	def filename_generator
		parameter_array = Array.new
		unless params[:name].blank?
			parameter_array << params[:name]
		end
		
		unless params[:state].blank?
			parameter_array << params[:state]
		 end
		
		unless params[:commodity].blank?
			parameter_array << params[:commodity]
		end
		
		
		 unless params[:status].blank?
			 parameter_array << params[:status].pluralize.parameterize.underscore
		 else
			 parameter_array << params[:controller]
		 end
				 
		 unless params[:action] == 'index'
			parameter_array << params[:action]
		 end
		 
		 if params[:action].in?(["jorc","resources"])
			parameter_array << "for_#{params[:year]}" unless params[:year].blank?
		 end
				
		parameter_array <<  Date.today.to_s.gsub(/-/,'')
		
		@filename = parameter_array.join('_')
	end

  def define_year
    if params[:year].blank?
      @year = 2010
    else
      @year = params[:year].to_i
    end
  end
  

end
