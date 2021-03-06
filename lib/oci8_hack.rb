#require 'geo_ruby'
#require 'rubygems'
#require 'oci8'

OCI8::Object::Base.class_eval do
  # module Mdsys; def SdoGeometry
  def as_georuby
    raise "geom should be a OCI8::Object::Mdsys::SdoGeometry" unless
    self.kind_of?(OCI8::Object::Mdsys::SdoGeometry)
    attributes = self.instance_variable_get("@attributes")
    # point?
    gtype = attributes[:sdo_gtype].to_i
    srid = attributes[:sdo_srid].to_i
    # gtype = dl0t (d=dim, l=?, t=type)
    m = gtype.to_s.match(/(\d)00(\d)/)
    d = m.values_at(1)[0].to_i
    t = m.values_at(2)[0].to_i
    if t == 1 # point
      coords=Array.new
      p = attributes[:sdo_point].instance_variable_get("@attributes")
      unless p==nil
        x = p[:x].to_f
        y = p[:y].to_f
        z = p[:z].to_f
        coords = [x, y, z]
      else
        elements = Array.new

        attributes[:sdo_elem_info].instance_variable_get("@attributes").each{|i|
          elements << i.to_i}
        if elements.size % 3 == 0
          elements = elements.in_groups_of(3)
        else
          raise "unidentified SDO_ELEM_INFO type"
        end

        attributes[:sdo_ordinates].instance_variable_get("@attributes").each{|c|
          coords << c.to_f}
      end
      if d == 3 # 3D point
        georb = GeoRuby::SimpleFeatures::Point.from_coordinates(coords,
          srid, true)
      elsif d == 2 # 2D point
        georb = GeoRuby::SimpleFeatures::Point.from_coordinates(coords,
          srid)
      else
        raise "Cannot handle this dimension of point #{d}"
      end
      return georb
      # s = Prod::Sample.find(1984851) # 2001
      # s = Prod::Sample.find(1978952) # 3001
      # #<OCI8::Object::Mdsys::SdoGeometry:0x3ed05a0
      # @attributes=
      #  {:sdo_point=>
      #    #<OCI8::Object::Mdsys::SdoPointType:0x3ed01e0
      #     @attributes=
      # {:x=>#<OraNumber:113.71801>, :y=>#<OraNumber:-30.01861>, :z=>nil},
        #     @con=nil>,
        #   :sdo_elem_info=>nil,
        #   :sdo_gtype=>#<OraNumber:3001>,
        #   :sdo_srid=>#<OraNumber:8311>,
        #   :sdo_ordinates=>nil},
        # @con=nil>
      elsif t==2 # LineString
        coords_dim =[]; coords = []

        attributes[:sdo_ordinates].instance_variable_get("@attributes").each{|c|
          coords << c.to_f}
        s = 0
        e = s+d-1
        while e < coords.size
          coords_dim << coords[s..e]
          s=e+1
          e=s+d-1
        end
        if d == 3 # 3D line
          georb = GeoRuby::SimpleFeatures::LineString.from_coordinates(coords_dim, srid,
            true)
        elsif d == 2 # 2D line
          georb = GeoRuby::SimpleFeatures::LineString.from_coordinates(coords_dim, srid)
        else
          raise "unsupported dimenstion for linestring: #{d}"
        end
        return georb
        # s = Prod::Sample.find(2002718)
        ##<OCI8::Object::Mdsys::SdoGeometry:0x3fac5b4
        # @attributes=
        #  {:sdo_point=>nil,
        #   :sdo_elem_info=>
        #    #<OCI8::Object::Mdsys::SdoElemInfoArray:0x3fab204
        #     @attributes=[#<OraNumber:1>, #<OraNumber:2>,
        #<OraNumber:1>],
        #     @con=nil>,
        #   :sdo_gtype=>#<OraNumber:3002>,
        #   :sdo_srid=>#<OraNumber:8311>,
        #   :sdo_ordinates=>
        #    #<OCI8::Object::Mdsys::SdoOrdinateArray:0x3faadcc
        #     @attributes=
        #      [#<OraNumber:110.85005>,
        #       #<OraNumber:-26.2319>,
        #       #<OraNumber:3107>,
        #       #<OraNumber:110.8473>,
        #       #<OraNumber:-26.23572>,
        #       #<OraNumber:3251>],
        #     @con=nil>},
        # @con=nil>
      elsif t==3 # Polygon
        polygon = Array.new
        coords = Array.new
        elements = Array.new

        attributes[:sdo_elem_info].instance_variable_get("@attributes").each{|i|
          elements << i.to_i}
        if elements.size % 3 == 0
          elements = elements.in_groups_of(3)
        else
          raise "unidentified SDO_ELEM_INFO type"
        end

        attributes[:sdo_ordinates].instance_variable_get("@attributes").each{|c|
          coords << c.to_f}
        i=0
        while i < elements.size
          linear_ring = Array.new
          s = elements[i].first - 1
          unless i == elements.size-1
            e = elements[i+1].first - 1
          else
            e = coords.size
          end
          n=s+d-1
          while s < e
            point = coords[s..n]
            linear_ring << point
            s=n+1
            n=s+d-1
          end
          polygon << linear_ring
          i+=1
        end
        if d == 3 # 3D line
          georb = GeoRuby::SimpleFeatures::Polygon.from_coordinates(polygon, 4326, true)
        elsif d == 2 # 2D line
          georb = GeoRuby::SimpleFeatures::Polygon.from_coordinates(polygon, 4326)
        else
          raise "unsupported dimenstion for linestring: #{d}"
        end
        return georb
      elsif t==6 # MULTILINESTRING
        
        multilinestring = Array.new
        coords=Array.new
        elements = Array.new
        attributes[:sdo_elem_info].instance_variable_get("@attributes").each{|item| elements << item.to_i}
        if elements.size % 3 == 0
          elements = elements.each_slice(3).to_a
        else
          raise "unidentified SDO_ELEM_INFO type"
        end
        attributes[:sdo_ordinates].instance_variable_get("@attributes").each{|c| coords << c.to_f}
        
        
        i=0
        while i < elements.size
          linestring = Array.new
          s = elements[i].first - 1

          unless i == elements.size-1
            e = elements[i+1].first - 1
          else
            e = coords.size
          end

          n=s+d-1
          while s < e
            point = coords[s..n]
            linestring << point
            s=n+1
            n=s+d-1
          end
          i+=1
          multilinestring << linestring
        end
        if d == 3 # 3D line
          georb = GeoRuby::SimpleFeatures::MultiLineString.from_coordinates(multilinestring,
            4326, true)
        elsif d == 2 # 2D line
          georb = GeoRuby::SimpleFeatures::MultiLineString.from_coordinates(multilinestring,
            4326)
        else
          raise "unsupported dimenstion for linestring: #{d}"
        end
        return georb
        
        
      elsif t==7 # MultiPolygon
        polygon = Array.new
        multipolygon = Array.new
        coords = Array.new
        elements = Array.new
        attributes[:sdo_elem_info].instance_variable_get("@attributes").each{|item| elements << item.to_i}
        if elements.size % 3 == 0
          elements = elements.each_slice(3).to_a
        else
          raise "unidentified SDO_ELEM_INFO type"
        end

        attributes[:sdo_ordinates].instance_variable_get("@attributes").each{|c| coords << c.to_f}
        i=0
        while i < elements.size
          linear_ring = Array.new
          s = elements[i].first - 1
          if elements[i].second == 1003
            multipolygon << polygon unless i==0
            polygon = Array.new
          end
          unless i == elements.size-1
            e = elements[i+1].first - 1
          else
            e = coords.size
          end

          n=s+d-1
          while s < e
            point = coords[s..n]
            linear_ring << point
            s=n+1
            n=s+d-1
          end
          polygon << linear_ring
          i+=1
        end
        multipolygon << polygon
        if d == 3 # 3D line
          georb = GeoRuby::SimpleFeatures::MultiPolygon.from_coordinates(multipolygon,
            4326, true)
        elsif d == 2 # 2D line
          georb = GeoRuby::SimpleFeatures::MultiPolygon.from_coordinates(multipolygon,
            4326)
        else
          raise "unsupported dimenstion for linestring: #{d}"
        end
        return georb
      else
        raise "unidentified SDO_GEOMETRY type"
      end
    end
  end