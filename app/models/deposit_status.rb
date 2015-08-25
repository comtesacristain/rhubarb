class DepositStatus < ActiveRecord::Base
   #TODO set relation with State
  # TODO Ugly name for the model. Think of a better one. Maybe worth calling _this_ the deposit model and the other one 'coordinates'


  self.table_name  = "mgd.deposits"
  self.primary_key  = :eno
  set_date_columns :entrydate, :qadate, :lastupdate
  
  
  #belongs_to :zone, :class_name => "Zone",  :foreign_key => :parent

  belongs_to :deposit, :class_name => "Deposit", :foreign_key => :eno
  
  # Queries 
    
  def self.status(status)
    where(:operating_status=>status)
  end
  
  def self.state(state)
    where(:state=>state)
  end
  
  def self.statuses
    return ActiveSupport::OrderedHash["All",nil,"Operating Mines","operating mine","Historic Mines","historic mine","Mineral Deposits","mineral deposit"]
  end
  
  #TODO Change this to use key lookups, find all atlas statuses in project first and change to atlas_status_as_keys 
    
  def self.atlas_statuses
    return ActiveSupport::OrderedHash["Operating Mines","operating mine","Historic Mines","historic mine","Mineral Deposits","mineral deposit"]
  end

  def self.operating_statuses
    return self.uniq.pluck(:operating_status)
  end

  def self.states
    return self.uniq.pluck(:state)
  end
  
  # Key Lookups
  
  def self.operating_statuses_as_keys(id=nil)
    unless id.nil?
      self.where(:operating_status=>id).operating_statuses.collect{|os| {:id=>os,:name=>os.titleize}}
    else
      self.operating_statuses.collect{|os| {:id=>os,:name=>os.titleize}}
    end
  end
  
  def self.states_as_keys(id=nil)
    return State.where(:stateid=>DepositStatus.states).find_as_keys
    
    # TODO Probably needs something for querying
    #unless id.nil?
    #  return State.find_as_keys(id)
    #else
    #  return State.find_as_keys(DepositStatus.states)
    #end
  end


end
