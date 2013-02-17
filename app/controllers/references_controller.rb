class ReferencesController < ApplicationController
  before_filter :define_scope, :only => [:index]
  #before_filter :require_user
  def index
    unless params[:format]
      @scope = @scope.paginate :page => params[:page] , :order => 'source ASC' unless params[:format]
	  else
      @scope = @scope.all
	  end
    @references=@scope

    respond_to do |format|

      format.html # index.html.erb
      format.xml  { render :xml => @references }
      
      format.xls
    end
  end

  def show
    @reference = Reference.find(params[:id])
  end

  private
  def define_scope
	  scope = Reference
    scope = scope.by_source(params[:source]) unless params[:source].nil?
	  @scope = scope
	end
end
