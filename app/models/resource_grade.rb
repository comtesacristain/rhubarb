class ResourceGrade < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.resource_grades"
	set_primary_key :resourceno
  set_date_columns :entrydate, :qadate, :confid_until, :lastupdate

  belongs_to :resource, :class_name => "Resource", :foreign_key => :resourceno

	#named_scope :recent, :conditions => "recorddate in (select MAX(recorddate) from mgd.resources r where r.eno = mgd.resources.eno"

  scope :public, :conditions=> "mgd.resource_grades.access_code = 'O'"

	scope :mineral, lambda { |min| { :conditions=> ["mgd.resource_grades.commodid = ?", min] } }
end
