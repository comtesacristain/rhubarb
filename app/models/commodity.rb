class Commodity < ActiveRecord::Base
	self.table_name = "mgd.commods"
	self.primary_key = :eno
    
	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :eno
	
	set_date_columns :entrydate, :qadate, :lastupdate

  #scopes
  
  def self.mineral(mineral)
    where(:commodid=>mineral)
  end
  
  def self.public
    self.where(:access_code=>'O')
  end

end

