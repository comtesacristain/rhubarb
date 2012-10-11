@deposits.each do |deposit|
  xml.tag! "Placemark" do
    xml.description do
      xml.cdata!("Name: #{link_to deposit.name, deposit}<br />
								State: #{deposit.deposit_status.try(:state)}<br />
								Commodities: #{deposit.commodity_list.try(:commodids)}")
    end
    xml.name deposit.name
    if deposit.deposit_status.operating_status == 'historic mine'
      if deposit.resources.recent.nonzero.empty?
        status = deposit.deposit_status.operating_status rescue nil
      else
        status = "historic mine with resources"
      end
    else
      status = deposit.deposit_status.operating_status rescue nil
    end
    xml.styleUrl "#"+status rescue nil
    xml.tag! "Point" do
      xml.coordinates "#{deposit.longitude},#{deposit.latitude}"
    end
  end
end