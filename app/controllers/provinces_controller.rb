class ProvincesController < ApplicationController
  before_filter :define_scope, :only => [:index]

  def index
    unless params[:format]
      @scope = @scope.paginate :page => params[:page] , :order => 'entityid ASC' unless params[:format]
	  else
      @scope = @scope.all
	  end

    @provinces=@scope

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @provinces}
      format.kml
    end
  end

  def show
    @province = Province.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @province }
      format.json
      format.kml
    end
  end

  private
  def define_scope
	  scope = Province
    scope = scope.by_name(params[:name]) unless params[:name].nil?
	  @scope = scope
	end
end
