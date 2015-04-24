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
      xml.description @survey.surveyname
      xml.name @survey.surveyname
      xml.styleUrl "#province"
      xml << @navigation.geom.as_georuby.as_kml unless @navigation.geom.nil?
    end
  end
end