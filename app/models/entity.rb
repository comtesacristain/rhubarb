class Entity < ActiveRecord::Base
  self.abstract_class = true

  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "a.entities"
  set_primary_key :eno
	set_date_columns :entrydate, :qadate, :confid_until, :lastupdate

  has_many :entity_attributes, :class_name => "EntityAttribute",  :foreign_key => :eno

  scope :bounds, lambda { |bbox| { :conditions => bounds_conditions(bbox) } }

  def name
    entityid
  end

  def latitude
    if geom != nil
      return geom.as_georuby.y
    end
  end

  def longitude
    if geom != nil
      return geom.as_georuby.x
    end
  end

  def self.bounds_conditions (bounds)
	  #bounds=eval(bounds) # the params hash is a string of an array, ie "[x0,y0,x1,y1]", needs to be converted - probably should do it in the controller
	  bbox = GeoRuby::SimpleFeatures::Polygon.from_coordinates(bounds.as_coordinates, 4326 )
    return geom_conditions(bbox)
	end

  def self.geom_conditions(g)
    conditions = ["SDO_ANYINTERACT(#{table_name}.geom, #{g.as_sdo_geometry}) = 'TRUE'"]
    return conditions
  end
  
end
