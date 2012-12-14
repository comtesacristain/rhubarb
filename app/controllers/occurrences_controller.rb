class OccurrencesController < ApplicationController
  before_filter :define_scope, :only => [:index]
  #before_filter :require_user
  # GET /occurrences
  # GET /occurrences.xml
  def index
    if !params[:format]
      @scope = @scope.paginate :page => params[:page] , :order => 'name ASC' if !params[:format]
	  else
      @scope = @scope.all
	  end
	  @occurrences = @scope

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @occurrences }
      format.kml
      format.csv
    end
  end

  def map

	  respond_to do |format|
      format.html # map.html.erb
    end
  end

  # GET /occurrences/1
  # GET /occurrences/1.xml
  def show
    @occurrence = Occurrence.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @occurrence }
    end
  end

  def define_scope
    scope = Occurrence
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
    
    unless params[:state].blank?
      @state = params[:state]
      scope = scope.state(@state)
    end
	  
    scope = scope.by_name(params[:name]) unless params[:name].blank?
	  scope = scope.bbox(eval("["+params[:bbox]+"]")) if params[:bbox]
	  @scope = scope
	end
end
