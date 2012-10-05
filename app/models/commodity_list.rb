class CommodityList < ActiveRecord::Base
  #connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.concat_commods"
	set_primary_key :idno

	belongs_to :deposit, :class_name => "Deposit"

	set_date_columns :entrydate, :qadate, :lastupdate
end
