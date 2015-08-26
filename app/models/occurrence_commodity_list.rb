class OccurrenceCommodityList < ActiveRecord::Base
	self.table_name "mgd.occurrence_concat_commods"
	self.primary_key :idno
	
	belongs_to :occurrence, :class_name => "Occurrence"
    
	set_date_columns :entrydate, :qadate, :lastupdate
end