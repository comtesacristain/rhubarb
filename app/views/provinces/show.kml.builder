xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
  xml.tag! "Document" do
    xml.tag! "Style", :id => "myStyle" do
      xml.tag! "PointStyle" do
        xml.color "ffff0000" #format is aabbggrr
        xml.outline 0
      end
    end
    xml.tag! "Placemark" do
      xml.description @province.entityid
      xml.name @province.entityid
      xml.styleUrl "#myStyle"
      xml << @province.geom.as_georuby.as_kml unless @province.geom.nil?
    end
  end
end