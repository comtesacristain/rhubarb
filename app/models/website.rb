class Website < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.websites"

	set_primary_key :websiteno

	
	has_many :weblinks, :class_name => "Weblink", :foreign_key => :websiteno

  has_many :deposits, :through => :weblinks

	set_date_columns :entrydate, :qadate, :lastupdate
	
	
	def self.by_name(name)
	  self.where("upper(description) like ?","%#{name.upcase}%")
	end
	
	# Key Lookups
	def self.find_with_deposit_as_keys(id=nil)
    #TODO where instead of find is dangerous when number of things is over 1000
    unless id.nil?
      self.where(:websiteno=>id).collect{|w| {:id=>w.websiteno,:name=>w.description}}
    else
      self.where(:websiteno=>Weblink.uniq.pluck(:websiteno)).collect{|w| {:id=>w.websiteno,:name=>w.description}}
    end
  end 
end
