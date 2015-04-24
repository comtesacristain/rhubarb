class Weblink < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.webdata"

	set_primary_key :eno

	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :eno
	belongs_to :website, :class_name => "Website", :foreign_key => :websiteno

  #default_scope :order => :weborder
	set_date_columns :entrydate, :qadate, :lastupdate
end
