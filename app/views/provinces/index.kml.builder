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
    @provinces.each do |province|
      if province.geom
        xml.tag! "Placemark" do
          xml.description do
            #TODO Change province deposits.
            deposits = province.province_deposits
            d=String.new
            deposits.each do |deposit|
              d << link_to(deposit.deposit.try(:entityid), "http://rhe-seismic:5000#{url_for(deposit.deposit)}.kml") +"<br />"
                                  
              end
              attribs = province.province_attribute
              xml.cdata!("<b>Name</b>: #{attribs.provname}<br />
                        <b>Type</b>: #{attribs.provtype.titleize}<br />
                        <b>Age</b>: #{attribs.maxagename} - #{attribs.minagename}<br />
                      <br />
                      <b>Deposits</b>:<br />"+d
              )
            end
            xml.name province.entityid
            xml.styleUrl "#myPolyStyle"
            begin
              xml << province.geom.as_georuby.as_kml
            rescue
              nil
            end
          end
        end
      end
    end
  end