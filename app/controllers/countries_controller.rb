class CountriesController < ApplicationController
  before_filter :define_scope, :only => [:index]

  def index
    unless params[:format]
      @scope = @scope.paginate :page => params[:page] , :order => 'entityid ASC' unless params[:format]
	  else
      @scope = @scope.all
	  end

    @countries=@scope

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @countries}
      format.kml
    end
  end

  def show
    @country = Country.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @country  }
      format.json
      format.kml
    end
  end

  private
  def define_scope
	  scope = Country
    scope = scope.by_name(params[:name]) unless params[:name].nil?
	  @scope = scope
	end
end
