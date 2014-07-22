class CompaniesController < ApplicationController
  def index
    @companies = Company.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    @company = Company.find(params[:id])
  end
  
  def companies
    unless params[:q].blank?
      @companies=Company.by_name(params[:q]).find_with_deposit_as_keys
    else
      @companies=Company.find_with_deposit_as_keys
    end
    
     respond_to do |format|
       format.json { render :json =>@companies}
     end
  end

end
