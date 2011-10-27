xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
  xml.tag! "Document" do
    xml.tag! "Style", :id => "operating mine" do
      xml.tag! "IconStyle" do
        xml.scale 0.4
        xml.tag! "Icon" do
          xml.href "http://rhe-seismic.ga.gov.au:5000/images/red-circle.png"
        end
        xml.outline 0
      end
    end
    xml.tag! "Style", :id => "mineral deposit" do
      xml.tag! "IconStyle" do
        xml.scale 0.4
        xml.tag! "Icon" do
          xml.href "http://rhe-seismic.ga.gov.au:5000/images/yellow-circle.png"
        end
        xml.outline 0
      end
    end
    xml.tag! "Style", :id => "historic mine" do
      xml.tag! "IconStyle" do
        xml.scale 0.4
        xml.tag! "Icon" do
          xml.href "http://rhe-seismic.ga.gov.au:5000/images/green-circle.png"
        end
        xml.outline 0
      end
    end
    @deposits.each do |deposit|
      xml.tag! "Placemark" do
        xml.description do
							xml.cdata!("Name: #{link_to deposit.name, deposit}<br />
								State: #{deposit.deposit_status.try(:state)}<br />
								Commodities: #{deposit.commodity_list.try(:commodids)}")
						end
        xml.name deposit.name
        xml.styleUrl "#"+deposit.deposit_status.operating_status rescue nil
        xml.tag! "Point" do
          xml.coordinates "#{deposit.longitude},#{deposit.latitude}"
        end
      end
    end
  end
end