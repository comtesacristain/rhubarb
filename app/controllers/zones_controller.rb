class ZonesController < ApplicationController
  before_filter :require_ozmin_user

  # GET /zones/1
  # GET /zones/1.xml
  def show
    @zone = Zone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @zone }
    end
  end

end
