class OccurrenceCommodityList < ActiveRecord::Base
	#connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.occurrence_concat_commods"
	set_primary_key :idno
	
	belongs_to :occurrence, :class_name => "Occurrence"
    
	set_date_columns :entrydate, :qadate, :lastupdate
end