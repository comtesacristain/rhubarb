class OccurrencesController < ApplicationController
  before_filter :define_scope, :only => [:index, :map]
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
      format.kml { render :action => 'index_kml', :layout => false }
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

  # GET /occurrences/1
  # GET /occurrences/1.xml
  def show
    @occurrence = Occurrence.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @occurrence }
    end
  end

  # GET /occurrences/new
  # GET /occurrences/new.xml
  def new
    @occurrence = Occurrence.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @occurrence }
    end
  end

  # GET /occurrences/1/edit
  def edit
    @occurrence = Occurrence.find(params[:id])
  end

  # POST /occurrences
  # POST /occurrences.xml
  def create
    @occurrence = Occurrence.new(params[:occurrence])

    respond_to do |format|
      if @occurrence.save
        format.html { redirect_to(@occurrence, :notice => 'Occurrence was successfully created.') }
        format.xml  { render :xml => @occurrence, :status => :created, :location => @occurrence }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @occurrence.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /occurrences/1
  # PUT /occurrences/1.xml
  def update
    @occurrence = Occurrence.find(params[:id])

    respond_to do |format|
      if @occurrence.update_attributes(params[:occurrence])
        format.html { redirect_to(@occurrence, :notice => 'Occurrence was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @occurrence.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /occurrences/1
  # DELETE /occurrences/1.xml
  def destroy
    @occurrence = Occurrence.find(params[:id])
    @occurrence.destroy

    respond_to do |format|
      format.html { redirect_to(occurrences_url) }
      format.xml  { head :ok }
    end
  end

  private
  def define_scope
    scope = Occurrence
	  if params[:commodity] and params[:commodity] != "All"
      if CommodityType.aliases.keys.include?(params[:commodity])
        commodity = CommodityType.aliases[params[:commodity]]
      else
        commodity = params[:commodity]
      end
      scope = scope.mineral(commodity)
	  end

	  scope = scope.state(params[:state]) if params[:state] and params[:state] != "All"
	  scope = scope.bbox(eval("["+params[:bbox]+"]")) if params[:bbox]
	  @scope = scope
	end
end
