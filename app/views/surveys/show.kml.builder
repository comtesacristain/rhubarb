xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
  xml.tag! "Document" do
    xml.tag! "Style", :id => "province" do
      xml.tag! "PolyStyle" do
        xml.color "77ffff00" #format is aabbggrr
        xml.fill 1
        xml.outline 1
      end
    end
    xml << render(:partial => 'deposits/style')
    xml.tag! "Placemark" do
      xml.description @province.entityid
      xml.name @province.entityid
      xml.styleUrl "#province"
      xml << @province.geom.as_georuby.as_kml unless @province.geom.nil?
    end
    #@deposits = @province.deposits
    #xml << render(:partial => 'deposits/deposits')
  end
end