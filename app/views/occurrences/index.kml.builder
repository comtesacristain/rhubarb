xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
  xml.tag! "Document" do
     xml.tag! "Style", :id => "occurrence" do
      xml.tag! "IconStyle" do
        xml.scale 0.25
        xml.tag! "Icon" do
          xml.href "#{root_url}assets/blue-circle.png"
        end
        xml.outline 0
      end
    end
    @occurrences.each do |occurrence|
      xml.tag! "Placemark" do
        xml.description do
          xml.cdata!("Name: #{link_to occurrence.name, occurrence}<br />
            State: #{occurrence.state}<br />
            Commodities: #{occurrence.commods}")
        end
        xml.name occurrence.name
        xml.styleUrl "#occurrence"
        xml.tag! "Point" do
          xml.coordinates "#{occurrence.longitude},#{occurrence.latitude}"
        end
      end
    end
  end
end