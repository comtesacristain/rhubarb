class Reference < ActiveRecord::Base
	self.table_name "georef.references"

	self.primary_key :refid

	has_many :resource_references, :class_name => "ResourceReference", :foreign_key => :refid
  has_many :resources, :through => :resource_references, :class_name => "Resource", :foreign_key => :resourceno

  
  has_many :authors, :class_name => "Author", :foreign_key => :refid

  scope :by_source, lambda { |source| { :include=>:authors, :conditions=> ["UPPER(georef.references.source) like UPPER(:source) or UPPER(georef.authors.author) like UPPER(:source)",{:source=> "%#{source}%"}] } }

	set_date_columns :entrydate, :qadate, :lastupdate

end
