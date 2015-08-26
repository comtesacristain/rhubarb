class OccurrenceCommodity < ActiveRecord::Base
  self.table_name "mgd.occurrence_commods"
	self.primary_key :minlocno
	
	belongs_to :occurrence, :class_name => "Occurrence"
    
	scope :mineral, lambda  { |min| {:conditions => ["commodid = ?" , min] } }
	
	set_date_columns :entrydate, :qadate, :lastupdate
end