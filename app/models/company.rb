class Company < ActiveRecord::Base
  self.table_name = "mgd.companies"
	
  has_many :ownerships, :class_name => "Ownership", :foreign_key => :companyid

  has_many :deposits, :through => :ownerships
  
  
	def self.by_name(name)
	  self.where("upper(company_name) like ?","%#{name.upcase}%")
	end
  
	def self.find_with_deposit_as_keys(id=nil)
    #TODO where instead of find is dangerous when number of things is over 1000
    unless id.nil?
      self.where(:companyid=>id).collect{|w| {:id=>w.companyid,:name=>w.company_name}}
    else
      self.where(:companyid=>Ownership.uniq.pluck(:companyid)).collect{|w| {:id=>w.companyid,:name=>w.company_name}}
    end
  end 
end
