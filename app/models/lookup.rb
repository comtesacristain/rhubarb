class Lookup < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.lookups"

	set_primary_key :code

  set_inheritance_column :ruby_type
  
	set_date_columns :entrydate, :qadate, :lastupdate
  
  def self.aimr_code
    return {'EDR'=>"economic",'DMP'=>"paramarginal",'DMS'=>"submarginal",'IFR'=>"inferred"}
  end
  
  def self.states
    return {"Australian Capital Territory"=>"ACT","New South Wales"=>"NSW","Northern Territory"=>"NT","Queensland"=>"QLD","South Australia"=>"SA","Tasmania"=>"TAS","Victoria"=>"VIC","Western Australia"=>"WA","Australia" => nil}
  end
  
  def self.operating_statuses
    return where(:type=>'OPERATING STATUS')
  end
  
  def self.by_value(value)
    return where("upper(value) like ?","%#{value.upcase}%")
  end
  
  
  def self.find_as_keys(keys=nil)
    #TODO This works for operating only. Change for other lookups
    unless keys.nil?
        self.where(:value=>keys).collect{|l| {:id=>l.value,:name=>l.value.titleize}}
      else
        self.all.collect{|l| {:id=>l.value,:name=>l.value.titleize}}
    end
      
  end
end