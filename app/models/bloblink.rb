class Bloblink < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "npm.bloblink"
    
	set_primary_key :eno
	
	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :source_no
	belongs_to :blob, :class_name => "Blob", :foreign_key => :blobno
	
	
	set_date_columns :entrydate, :qadate, :lastupdate
end