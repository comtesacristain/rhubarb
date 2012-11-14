domain='lws-60603:3000'
xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
  xml.tag! "Document" do
    xml.tag! "Style", :id => "major_project" do
      xml.tag! "IconStyle" do
        xml.scale 0.4
        xml.tag! "Icon" do
          xml.href "http://#{domain}/images/pink-star.png"
        end
        xml.outline 0
      end
    end
    @major_projects.each do |major_project|
      xml.tag! "Placemark" do
        xml.description do
							xml.cdata!("Name: #{link_to major_project.entityid, major_project}<br />
                         State: #{major_project.entity_attributes.state}<br />
                         Qualifier: #{major_project.eid_qualifier}								")
						end
        xml.name major_project.entityid
        xml.styleUrl "#major_project"
        xml.tag! "Point" do
          xml.coordinates "#{major_project.geom.sdo_point.x},#{major_project.geom.sdo_point.y}"
        end
      end
    end
  end
end