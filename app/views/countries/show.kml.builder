xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
  xml.tag! "Document" do
    xml.tag! "Style", :id => "country" do
      xml.tag! "PolyStyle" do
        xml.color "77ffff00" #format is aabbggrr
        xml.fill 1
        xml.outline 1
      end
    end
    xml << render(:partial => 'deposits/style')
    xml.tag! "Placemark" do
      xml.description @country.entityid
      xml.name @country.entityid
      xml.styleUrl "#province"
      xml << @country.geom.as_georuby.as_kml unless @country.geom.nil?
    end
    #@deposits = @province.deposits
    #xml << render(:partial => 'deposits/deposits')
  end
end