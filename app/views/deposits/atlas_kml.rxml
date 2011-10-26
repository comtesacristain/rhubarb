commods= {"bauxite"=>"ff00aa00","chromium"=>"ff00aaaa","coal"=>"ff000068","cobalt"=>"ffff0055",
  "copper"=>"ff2968bc","diamond"=>"ffffffff","gold"=>"ff0fdbff","gypsum"=>"ff7f5555",
  "iron_ore"=>"ff3560be","kaolin"=>"ff000055","lead"=>"ff910622","manganese_ore"=>"ff7fAAff",
  "magnesite"=>"ff6b2391","mineral_sands"=>"ffbfde4e","nickel"=>"ffeabee0","opal"=>"ffff8250",
  "phosphate"=>"ffd8d8d8","silica_sands"=>"ff7fff55","silver"=>"ffcccccc","talc"=>"ff7faaaa",
  "tantalum"=>"ff216bff","tin"=>"ff916e44","tungsten"=>"ffffaa55","uranium"=>"ff825537",
  "vermiculite"=>"ff005500","zinc"=>"ff009100"}


#commods= {"black_coal"=>"ff333333","brown_coal"=>"ff000068"}

xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
	xml.tag! "Document" do
		xml.name "Operating Mines in Australia (#{Date.today.year})"
		xml.tag! "description" do
			xml.cdata!("Data from the <a href='http://www.australianminesatlas.gov.au'>Australian Mines Atlas</a><br />
        <br />
        Generated on #{Date.today}")
		end
		xml.tag! "LookAt" do
			xml.longitude 131.2136173860096
			xml.latitude -27.48334873514817
			xml.altitude 0
			xml.range 5095631.459953479
			xml.tilt 5.331969522077021e-014
			xml.heading 1.972444439134081
		end
		commods.each do |key,value|
			xml.tag! "Style", :id => key do
				xml.tag! "IconStyle" do
					xml.color value
					xml.tag! "Icon" do
						xml.href "http://maps.google.com/mapfiles/kml/pal4/icon25.png"
					end
					xml.outline 0
				end
			end
		end
		commods.keys.sort.each do |commod|
			xml.tag! "Folder" do
				xml.name commod.titleize
				@deposits.mineral(CommodityType.aliases[CommodityType.all_commodities[commod.titleize]] || CommodityType.all_commodities[commod.titleize]).each do |deposit|
					xml.tag! "Placemark" do
						xml.description do
							webstring = String.new
							deposit.websites.each do |website|
								webstring << "<a href='#{website.url}'>#{website.description}</a><br />"
							end
							xml.cdata!("Name: #{deposit.name}<br />
								State: #{deposit.deposit_status.state}<br />
								Longitude: #{"%3.6f" % deposit.longitude}<br />
								Latitude: #{"%3.6f" % deposit.latitude}<br />
								Commodities: #{deposit.commodity_list.commodnames}<br />
								Websites:<br /><br />#{webstring}")
						end
						xml.tag! "LookAt" do
							xml.longitude deposit.longitude
							xml.latitude deposit.latitude
							xml.altitude 0
							xml.range 5000
							xml.tilt 60
							xml.heading 0
						end
						xml.name deposit.name
						xml.styleUrl "##{commod}"
						xml.tag! "Point" do
							xml.coordinates "#{deposit.longitude},#{deposit.latitude}"
						end
					end
				end
			end
		end
	end
end