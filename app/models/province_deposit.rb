class ProvinceDeposit < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.provlink"

	set_primary_key :deposno

	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :eno
	belongs_to :province, :class_name => "Province", :foreign_key => :proveno


	set_date_columns :entrydate, :qadate, :lastupdate
end
