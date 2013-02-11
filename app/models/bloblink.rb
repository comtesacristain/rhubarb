class Bloblink < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	self.table_name = "npm.bloblink"
    
	self.primary_key = :eno
	
	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :source_no
	belongs_to :blob, :class_name => "Blob", :foreign_key => :blobno
	
	
	set_date_columns :entrydate, :qadate, :lastupdate
end