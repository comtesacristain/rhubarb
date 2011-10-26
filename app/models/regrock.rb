class Regrock < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.regrocks"

	set_primary_key :regrockno
	#ignore_table_columns :localdata, :comments, :thumbnail

	has_one :stratname, :class_name => "Stratname", :foreign_key => :stratno
	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :eno

	set_date_columns :entrydate, :qadate, :lastupdate
end