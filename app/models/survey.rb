class Survey < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
  self.table_name = "a.surveys"
  
  has_one :navigation, :class_name=>"Navigation", :foreign_key => :eno
  
  
  
  # Queries
  
  def self.survey_type(type)
    self.where(:surveytype=>type)
  end
  
  def self.operator(operator)
    self.where("upper(operator) like ?","%#{operator.upcase}%")
  end
  
  def self.vessel(vessel)
    self.where("upper(vessel) like ?","%#{vessel.upcase}%")
  end
  
  #TODO remove SQL injection risk
  def self.by_name(name)
    self.where("upper(surveyname) like ?", "%#{name.upcase}%")
  end
  
  # Lookups
  
  def self.types
    return self.uniq.pluck(:surveytype)
  end
  
  def self.vessels(vessel=nil)
    unless vessel.nil?
      return self.vessel(vessel).uniq.pluck(:vessel)
    else
      return self.uniq.pluck(:vessel)
    end
  end
  
  
  def self.names(name=nil)
    unless name.nil?
      return self.by_name(name).uniq.pluck(:surveyname)
    else
      return self.uniq.pluck(:surveyname)
    end
  end
  
  def self.operators(operator=nil)
    unless operator.nil?
      return self.operator(operator).uniq.pluck(:operator) 
    else
      self.uniq.pluck(:operator) 
    end
  end
  
end
