class CommodityList < ActiveRecord::Base
	self.table_name = "mgd.concat_commods"
	self.primary_key = :idno

	belongs_to :deposit, :class_name => "Deposit"

	set_date_columns :entrydate, :qadate, :lastupdate
end
