class ResourceReference < ActiveRecord::Base

	self.table_name = "mgd.resource_refs"

	self.primary_key = :resourceno

	belongs_to :resource, :class_name => "Deposit", :foreign_key => :resourceno
	belongs_to :reference, :class_name => "Reference", :foreign_key => :refid


	set_date_columns :entrydate, :qadate, :lastupdate
end
