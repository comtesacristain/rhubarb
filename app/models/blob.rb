class Blob < ActiveRecord::Base
	self.table_name  = "npm.all_blobs"
    
	self.primary_key = :blobno

  default_scope :limit => 50

	#has_many :deposits, :class_name => "Deposit", :foreign_key => :eno
	has_many :bloblinks, :class_name => "Bloblink", :foreign_key => :blobno
	
	set_date_columns :entrydate, :qadate, :lastupdate

  # Hack to get around thumbnail problem
  def safe(blobno)
    Blob.find_by_sql(["select localdata, name from npm.all_blobs where blobno = :blobno", {:blobno=>blobno}])
  end
end