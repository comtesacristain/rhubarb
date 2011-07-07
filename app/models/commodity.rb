class Commodity < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.commods"
	set_primary_key :eno
    
	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :eno
	named_scope :mineral, lambda  { |min| {:conditions => ["commodid = ?" , min] } }
	set_date_columns :entrydate, :qadate, :lastupdate


  scope :public, :include=>:commodities, :conditions=> "mgd.commods.access_code = 'O'"
end

