GeoRuby::SimpleFeatures::LineString.class_eval do

  def polyline_representation
    gpe = GMapPolylineEncoder.new
    point_array = Array.new
    points.each do |point|
      point_array << [point.y, point.x]
    end
    encoded_polyline = gpe.encode(point_array)
    encoded_polyline
    
  end

end