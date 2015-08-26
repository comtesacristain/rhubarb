class Ownership < ActiveRecord::Base
  self.table_name = "mgd.ownership"
  
	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :eno
	belongs_to :company, :class_name => "Company", :foreign_key => :companyid
end
