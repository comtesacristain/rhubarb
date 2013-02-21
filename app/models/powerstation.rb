class Powerstation < ActiveRecord::Base

  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "a.v_powerstation_attribs"
	set_primary_key :eno

	ignore_table_columns :class

	default_scope :conditions => "activity_code ='A' and (image_name not like 'icon%.jpg' or image_name is null)", :order => "name"

  scope :by_name, lambda { |name| { :conditions=> ["UPPER(a.v_powerstation_attribs.name) like UPPER(:name)",{:name=> "%#{name}%"}] } }

	scope :fossil_fuel, :conditions => "class not like 'Renewable' and Total_capacity > 19"
	scope :renewable, :conditions => "class = 'Renewable' and Total_capacity >  30"

	scope :operating, :conditions => "status not like 'Proposed'"
	scope :proposed, :conditions => "status like 'Proposed'"

	#FOSSIL

	scope :black_coal, :conditions => "fuel_type in ('Black Coal','Black Coal/Gas')"
	scope :brown_coal, :conditions => "fuel_type in ('Brown Coal')"
	scope :gas, :conditions => "fuel_type in ('Gas','Gas/Other')"
	scope :distillate, :conditions => "fuel_type in ('Distillate')"

	#RENEWABLE

	scope :solar, :conditions => "fuel_type in ('Solar','Solar/Fossil')"
	scope :wind, :conditions => "fuel_type = 'Wind'"
	scope :hydro, :conditions => "fuel_type = 'Hydro'"
	scope :geothermal, :conditions => "fuel_type = 'Geothermal'"
	scope :tidal, :conditions => "fuel_type in ('Ocean (tidal)','Ocean (wave)')"

	scope :other, :conditions => "fuel_type in ('Other')"

	scope :waste, :conditions => "fuel_type in ('Biomass (landfill methane)','Biomass (municipal waste)','Biomass (sewage methane)')"
	scope :biomass, :conditions => "fuel_type in ('Biomass','Biomass (animal waste)','Biomass (bagasse)','Biomass (biogas)','Biomass (digester gas)','Biomass (wood)','Biomass (woodwaste)')"

	#scope :mineral, lambda  { |min| {:conditions => ["commodid = ?" , min] } }

end
