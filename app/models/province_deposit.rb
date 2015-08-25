class ProvinceDeposit < ActiveRecord::Base
	self.table_name = "provs.provdepos"

	self.primary_key =  :deposno

	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :deposno
	belongs_to :province, :class_name => "Province", :foreign_key => :eno

	set_date_columns :entrydate, :qadate, :lastupdate
	
	
end
