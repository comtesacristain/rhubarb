class Author < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "georef.authors"

	set_primary_key :refauthno
	#ignore_table_columns :localdata, :comments, :thumbnail

	#has_many :deposits, :class_name => "Deposit", :foreign_key => :eno
	belongs_to :reference, :class_name => "Reference", :foreign_key => :refid

	set_date_columns :entrydate, :qadate, :lastupdate
end