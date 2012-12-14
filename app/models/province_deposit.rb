class ProvinceDeposit < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	
	set_table_name "provs.provdepos"

	set_primary_key :deposno

	belongs_to :deposit, :foreign_key => :deposno
	belongs_to :province, :foreign_key => :eno

	set_date_columns :entrydate, :qadate, :lastupdate
	
	
end
