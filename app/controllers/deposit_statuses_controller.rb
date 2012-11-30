class DepositStatusesController < ApplicationController
  # JSON lookups

  def states
    #@states = DepositStatus.states_as_keys(params[:q])
    
    unless params[:q].blank?
      @states = State.by_name(params[:q]).where(:stateid=>DepositStatus.states).find_as_keys
    else
      @states = State.where(:stateid=>DepositStatus.states).find_as_keys
    end
    
    
    respond_to do |format|
      format.json {render :json => @states}
    end
  end
  
  def operating_statuses
    @operating_statuses = DepositStatus.operating_statuses_as_keys(params[:q])
    respond_to do |format|
      format.json {render :json => @operating_statuses}
    end
  end
 
end
