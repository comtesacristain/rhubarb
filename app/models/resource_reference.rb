class ResourceReference < ActiveRecord::Base

  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.resource_refs"

	set_primary_key :resourceno

	belongs_to :resource, :class_name => "Deposit", :foreign_key => :resourceno
	belongs_to :reference, :class_name => "Reference", :foreign_key => :refid


	set_date_columns :entrydate, :qadate, :lastupdate
end
