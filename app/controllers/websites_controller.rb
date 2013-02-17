class WebsitesController < ApplicationController
  def index
    @websites = Website.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    @website = Website.find(params[:id])
  end
  
  def companies
    unless params[:q].blank?
      @companies=Website.by_name(params[:q]).find_with_deposit_as_keys
    else
      @companies=Website.find_with_deposit_as_keys
    end
    
     respond_to do |format|
       format.json { render :json =>@companies}
     end
  end

end
