class SurveysController < ApplicationController
  before_filter :define_scope, :only => [:index]

  def index
    unless params[:format]
      @scope = @scope.paginate :page => params[:page] , :order => :surveyname unless params[:format]
    else
      @scope = @scope.all
    end
    
    @types = {"Any"=>nil}.merge(Hash[Survey.types.map {|key,value| [key.titleize, key]}])
    
    @surveys=@scope

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @surveys}
      format.kml
    end
  end

  def show
    @survey = Survey.find(params[:id])
    @navigation =@survey.navigation

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @survey  }
      format.json
      format.kml
    end
  end
  
  # JSON lookups
  
  def vessels
    vessels = Survey.vessels(params[:q])
    @vessels = vessels.collect {|v| Hash[:id,v,:name,v]}
    respond_to do |format|
      format.json {render :json => @vessels}
    end
  end
  
  def names
    names=Survey.names(params[:q])
    @names = names.collect  {|name| Hash[:id,name,:name,name]}
    respond_to do |format|
      format.json {render :json => @names}
    end
  end
  
  def operators
    operators=Survey.operators(params[:q])
    @operators = operators.collect  {|operator| Hash[:id,operator,:name,operator]}
    respond_to do |format|
      format.json {render :json => @operators}
    end
  end

  private
  def define_scope
    scope = Survey
    
    scope = scope.survey_type(params[:type]) unless params[:type].blank?
    scope = scope.operator(params[:operator]) unless params[:operator].blank?
    scope = scope.vessel(params[:vessel]) unless params[:vessel].blank?
    scope = scope.by_name(params[:name]) unless params[:name].blank?
    @scope = scope.includes(:navigation)
  end
end
