class ResourceReference < ActiveRecord::Base

	self.table_name = "mgd.resource_refs"

	self.primary_key = :resourceno

	belongs_to :resource, :foreign_key => :resourceno
	belongs_to :reference, :foreign_key => :refid


	set_date_columns :entrydate, :qadate, :lastupdate
end
