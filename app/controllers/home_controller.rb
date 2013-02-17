class HomeController < ApplicationController
  before_filter :require_user
  def index
  end

  def search
    @deposits = Deposit.by_name(params[:q])
    @occurrences = Occurrence.by_name(params[:q])
     respond_to do |format|
      format.html 
    end
  end

  def new_features
  end

  def help
  end
end
