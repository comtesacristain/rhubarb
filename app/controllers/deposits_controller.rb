class DepositsController < ApplicationController
  #TODO put a pull_params filter here like that found in the Resources Controller

  before_filter :define_scope, :only => [:index, :mineral_system, :map, :resources, :quality_check, :atlas, :jorc, :qa]
  before_filter :define_year, :only => [:resources, :jorc]
  #before_filter :require_ozmin_user, :only => [:resources, :quality_check]
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
    
    #TODO Fix the below so aliases are included
    #if params[:commodity] and params[:commodity] != "All"
    #  if CommodityType.aliases.keys.include?(params[:commodity])
    #    @commodity = CommodityType.aliases[params[:commodity]]
    #  else
    #    @commodity = params[:commodity]
    #  end
 	  #end
 	  #Check for all commodities. Better if split
 	  #if @commodity.class == String
 	  #  @commodity=@commodity.split(",")
 	  #end

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

  def qa
    scope = @scope
    unless params[:qa_status_code].blank?
      scope= scope.where(:qa_status_code=> params[:qa_status_code])
    end
    @total_deposits = scope.count
    @qaed = scope.where(:qa_status_code=>'C').count
    @not_qaed = scope.where(:qa_status_code=>'U').count
    @no_geometry = scope.where(:geom=>nil).count
    @no_provinces = scope.includes(:province_deposits).where(ProvinceDeposit.table_name=> {:eno => nil}).count

    
    @bad_deposits =  scope.includes(:province_deposits).where(ProvinceDeposit.table_name=> {:eno => nil}).where(:qa_status_code=>'U').where(:geom=>nil)
  end

  # GET /deposits/1
  # GET /deposits/1.xml
  def show
    deposit = Deposit
    unless (current_user) # && current_user.ozmin?)
      deposit = deposit.public
    end
    @deposit = deposit.find(params[:id].to_i)
    
    
    # TODO When fetching resource records check if public
    @zones=@deposit.zones
    current_zones = @zones.includes(:resources).merge(Resource.recent.nonzero).all
    zeroed_zones = @zones.includes(:resources).merge(Resource.recent.zeroed).all
    empty_zones = @zones.includes(:resources).where(:resources => {:eno => nil}).all
    @zone_array = [current_zones,zeroed_zones,empty_zones]
    @current_resources = @deposit.resources.recent.nonzero.all
    @provinces = @deposit.provinces
    
    
    @weblinks = @deposit.weblinks

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deposit }
      format.kml
    end
  end
  
  def edit
    id=params[:id].to_i
    @deposit=Deposit.find(id)
    @deposit.province_deposits.build
    @provinces = @deposit.provinces
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def update
    id=params[:id].to_i
    @deposit = Deposit.find(params[:id])
    attributes=params[:deposit]
    #attributes[:province_deposits][:province]=attributes[:province_deposits][:province].split(",")
    @deposit.update_attributes(attributes) ?
      redirect_to(deposit_path(@deposit )) : render(:action => :edit)
  end
  
  # JSON look ups
  
  def names
    names=Deposit.order(:entityid).names(params[:q])
    @names = names.collect  {|name| Hash[:id,name,:name,name]}
    respond_to do |format|
      format.json {render :json => @names}
    end
  end
  
  # Private

  private
  def define_scope
      
    #TODO Possibly change to be like Websites below  
	  scope =  unless params[:province_id].blank?
	    Province.find(params[:province_id]).deposits
    else
      Deposit
    end
    
    unless params[:company_id].blank?
      scope = scope.joins(:websites).where(:websites=>{:websiteno=>params[:company_id]})
    end
    
    unless (current_user ) #&& current_user.ozmin?
      scope = scope.public
    end
    
    unless params[:commodity].blank?
      if CommodityType.aliases.keys.include?(params[:commodity])
        @commodity = CommodityType.aliases[params[:commodity]]
      else
        @commodity = params[:commodity].split(",")
      end
      unless (current_user && current_user.ozmin?)
        scope = scope.mineral(@commodity).merge(Commodity.public)
      else
        scope = scope.mineral(@commodity)
      end
	  end
    #
    unless params[:state].blank?
      @state=params[:state].split(",")
      scope = scope.state(@state)
    end
    
    unless params[:status].blank?
      @status=params[:status].split(",")
      scope = scope.status(@status)
    end
 	  
	  # TODO ugh no!
	  scope = scope.bounds(eval("["+params[:bbox]+"]")) unless params[:bbox].blank?
	  
	  scope = scope.by_name(params[:name]) unless params[:name].blank?
	  @scope = scope
	end

  #TODO Should this be in a helper?

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
