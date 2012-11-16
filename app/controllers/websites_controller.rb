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

end
