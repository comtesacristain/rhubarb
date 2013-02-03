xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
  xml.tag! "Document" do
    xml << render(:partial => 'deposits/style')
    xml.tag! "Placemark" do
      xml.description do
        xml.cdata!("Name: #{link_to @deposit.name, @deposit}<br />
								State: #{@deposit.deposit_status.try(:state)}<br />
								Commodities: #{@deposit.commodity_list.try(:commodids)}")
      end
      xml.name @deposit.name
      xml.styleUrl "#"+@deposit.deposit_status.operating_status rescue nil
      xml.tag! "Point" do
        xml.coordinates "#{@deposit.longitude},#{@deposit.latitude}"
      end
    end
  end
end