class CommodityTypesController < ApplicationController
 # before_filter :define_scope, :only => [:index]
  #before_filter :require_user
  # GET /major_projects
  # GET /major_projects.xml
  def index
    
    unless params[:q].blank?
      @commodity_types = CommodityType.by_name(params[:q]).find_as_keys
    else
      @commodity_types = CommodityType.find_as_keys
    end


    respond_to do |format|
      format.json {render :json => @commodity_types}
    end
  end

  # GET /major_projects/1
  # GET /major_projects/1.xml
end