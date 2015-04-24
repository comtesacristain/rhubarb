class Stratname < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "geodx.stratnames"

	set_primary_key :stratno
	#ignore_table_columns :localdata, :comments, :thumbnail

	#has_many :deposits, :class_name => "Deposit", :foreign_key => :eno
	belongs_to :regrock, :class_name => "Regrock", :foreign_key => :stratno

	set_date_columns :entrydate, :qadate, :lastupdate
end