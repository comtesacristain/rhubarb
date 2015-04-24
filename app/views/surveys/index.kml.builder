xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
  xml.tag! "Document" do
    xml.tag! "Style", :id => "myPolyStyle" do
      xml.tag! "PolyStyle" do
        xml.color "88ffffff" #format is aabbggrr
        xml.colorMode "random"
        xml.outline 1
      end
      xml.tag! "LineStyle" do
        xml.color "ffffffff"
        xml.width 2
      end
    end
    @surveys.each do |survey|
      if survey.navigation.geom
        xml.tag! "Placemark" do
          xml.name survey.surveyname
          xml.styleUrl "#myPolyStyle"
          begin
            xml << survey.navigation.geom.as_georuby.as_kml
          rescue
            nil
          end
          end
        end
      end
    end
  end