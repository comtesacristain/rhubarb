class PowerstationsController < ApplicationController
  # GET /powerstations
  # GET /powerstations.xml
  before_filter :define_scope, :only => [:index]
  #before_filter :require_user

  def index
    unless params[:format]
      @scope = @scope.paginate :page => params[:page] , :order => 'name ASC' unless params[:format]
	  else
      
	  end
    @powerstations=@scope

    respond_to do |format|

      format.html # index.html.erb
      format.kml
      format.csv
    end
  end

  def map

    respond_to do |format|
      format.html # map.html.erb
    end
  end

  def renewable
    @powerstations = Powerstation.renewable

    respond_to do |format|
      format.kml 
    end
  end

  def fossil
    @powerstations = Powerstation.fossil_fuel

    respond_to do |format|
      format.kml 
    end
  end

  # GET /powerstations/1
  # GET /powerstations/1.xml
  def show
    @powerstation = Powerstation.find(params[:id])
#
#    @map = GMap.new("map_div")
#    @map.set_map_type_init(GMapType::G_SATELLITE_MAP)
#    @map.control_init(:small_map => true,:map_type => false)
#    @map.center_zoom_init([@powerstation.latitude,@powerstation.longitude],15)
#    @map.overlay_init(GMarker.new([@powerstation.latitude,@powerstation.longitude],:title => "#{@powerstation.name}", :info_window => "#{@powerstation.name}"))


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @powerstation }
    end
  end

  private
  def define_scope
	  scope = Powerstation
    scope = scope.by_name(params[:name]) unless params[:name].nil?
	  @scope = scope
	end
end
