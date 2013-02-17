class LookupsController < ApplicationController
 # before_filter :define_scope, :only => [:index]
  #before_filter :require_user
  # GET /major_projects
  # GET /major_projects.xml
 
 def operating_statuses
   
 
   unless params[:q].blank?
   @values = Lookup.operating_statuses.by_value(params[:q]).find_as_keys
   else
     @values = Lookup.operating_statuses.find_as_keys
   end
   
    respond_to do |format|
      format.json {render :json => @values}
    end
 end

  # GET /major_projects/1
  # GET /major_projects/1.xml
end