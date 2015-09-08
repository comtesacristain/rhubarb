class Author < ActiveRecord::Base
	self.table_name = "georef.authors"

	self.primary_key = :refauthno
	#ignore_table_columns :localdata, :comments, :thumbnail

	#has_many :deposits, :class_name => "Deposit", :foreign_key => :eno
	belongs_to :reference, :class_name => "Reference", :foreign_key => :refid

	set_date_columns :entrydate, :qadate, :lastupdate
end