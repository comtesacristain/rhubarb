class Company < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
  self.table_name = "mgd.companies"
	
  has_many :ownerships, :class_name => "Ownership", :foreign_key => :companyid

  has_many :deposits, :through => :ownerships
  
end
