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