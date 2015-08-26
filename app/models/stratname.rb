class Stratname < ActiveRecord::Base
	self.table_name "geodx.stratnames"

	self.primary_key :stratno
  
	belongs_to :regrock, :class_name => "Regrock", :foreign_key => :stratno

	set_date_columns :entrydate, :qadate, :lastupdate
end