class Regrock < ActiveRecord::Base
	self.table_name "mgd.regrocks"
	self.primary_key :regrockno

	has_one :stratname, :class_name => "Stratname", :foreign_key => :stratno
	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :eno

	set_date_columns :entrydate, :qadate, :lastupdate
end