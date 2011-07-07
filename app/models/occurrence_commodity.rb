class OccurrenceCommodity < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.occurrence_commods"
	set_primary_key :minlocno
	
	belongs_to :occurrence, :class_name => "Occurrence"
    
	named_scope :mineral, lambda  { |min| {:conditions => ["commodid = ?" , min] } }
	
	set_date_columns :entrydate, :qadate, :lastupdate
end