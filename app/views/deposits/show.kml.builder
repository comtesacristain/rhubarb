xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
  xml.tag! "Document" do
    xml.tag! "Style", :id => "myStyle" do
      xml.tag! "PointStyle" do
        xml.color "ffff0000" #format is aabbggrr
        xml.outline 0
      end
    end
    xml.tag! "Placemark" do
      xml.description @deposit.entityid
      xml.name @deposit.entityid
      xml.styleUrl "#myStyle"
      xml << @deposit.geom.as_georuby.as_kml
    end
  end
end