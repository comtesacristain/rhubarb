class Occurrence < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")

	set_table_name "mgd.v_minloc"
	#set_table_name "mgd.occurrences"
	ignore_table_columns :class
	set_primary_key :minlocno

	has_many :occurrence_commodities, :class_name => "OccurrenceCommodity",  :foreign_key => "minlocno"
	#has_one :occurrence_commodity_list, :class_name => "OccurrenceCommodityList",  :foreign_key => "idno"

	#named_scope :copper, :joins=>:occurrence_commodities, :conditions=> "mgd.occurrence_commods.commodid = 'Cu'"
	#named_scope :uranium, :joins=>:occurrence_commodities, :conditions=> "mgd.occurrence_commods.commodid = 'U'"

	scope :mineral, lambda { |min| { :include=>:occurrence_commodities, :conditions=> ["mgd.occurrence_commods.commodid in (?)", min] } }
	scope :state, lambda { |s| { :conditions=> ["state = ?", s] } }
  scope :by_name, lambda { |name| { :conditions=> ["UPPER(mgd.v_minloc.name) like UPPER(:name)",{:name=> "%#{name}%"}] } }

	scope :bbox, lambda { |bbox| { :conditions => ["longitude > ? and latitude > ? and longitude < ? and latitude < ?", bbox[0],bbox[1],bbox[2],bbox[3] ]} }

	scope :pge, :conditions=> "upper(commdnames) like '%PLATINUM%' or upper(commdnames) like '%PALLADIUM%' or upper(commdnames) like '%OSMIUM%' or upper(commdnames) like '%IRIDIUM%' or upper(commdnames) like '%RHODIUM%' or upper(commdnames) like '%RUTHENIUM%'"

	#named_scope :pge, :joins=>:occurrence_commodities, :conditions=> "mgd.occurrence_commods.commodid = 'Pt' or mgd.occurrence_commods.commodid = 'PGE' or mgd.occurrence_commods.commodid = 'Pd' or mgd.occurrence_commods.commodid = 'Os' or mgd.occurrence_commods.commodid = 'Ir' or mgd.occurrence_commods.commodid = 'Rh' or mgd.occurrence_commods.commodid = 'Ru'"

	#named_scope :pge, :joins=>:occurrence_commodities, :conditions=> "commodid in ('Pt', 'PGE', 'Pd', 'Os', 'Ir', 'Rh', 'Ru')"
	set_date_columns :entrydate, :qadate, :lastupdate

  unless defined? self.commodids
    def self.commodids
      return self.commods
    end
  end

#  def longitude
#    dlong
#  end

#  def latitude
#    dlat
#  end

end