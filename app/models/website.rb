class Website < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.websites"

	set_primary_key :websiteno

	
	has_many :weblinks, :class_name => "Weblink", :foreign_key => :websiteno

  has_many :deposits, :through => :weblinks

	set_date_columns :entrydate, :qadate, :lastupdate
	

	
end
