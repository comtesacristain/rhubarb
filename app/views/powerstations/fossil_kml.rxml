fuel_types= {"black_coal"=>"http://www.wikienergy.de/img/wiki_steinkohle.png","brown_coal"=>"http://www.wikienergy.de/img/wiki_braunkohle.png",
  "gas"=>"http://www.wikienergy.de/img/wiki_erdgas.png",
  "distillate"=>"http://www.wikienergy.de/img/wiki_erdoel.png","other"=>"http://www.wikienergy.de/img/wiki_sonstiges.png"}

statuses =["operating","proposed"]

xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
	xml.tag! "Document" do
		xml.name "Fossil Fuel Powerstations in Australia (#{Date.today.year})"
		xml.tag! "description" do
			xml.cdata! ("Data from the <a href='http://www.ga.gov.au/fossil_fuel/'>Department of Environment, Water, Heritage and the Arts</a><br />
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
		fuel_types.each do |key,value|
			xml.tag! "Style", :id => key do
				xml.tag! "IconStyle" do
					xml.tag! "Icon" do
						xml.href value
					end
					xml.outline 0
				end
			end
		end
		statuses.each do |status|
			xml.tag! "Folder" do
				xml.name status.titleize
				fuel_types.keys.sort.each do |fuel_type|
					xml.tag! "Folder" do
						xml.name fuel_type.titleize
						@powerstations.send(status).send(fuel_type).each do |powerstation|
							xml.tag! "Placemark" do
								xml.description do
									xml.cdata! ("<table><tr><td><img src='http://www.ga.gov.au/fossil_fuel/#{powerstation.image_name}' /></td><td width='200px'>
										Information for <b><em>#{powerstation.name}</em></b><br />
                    <ul>
                    <li><em>Fuel type:</em> #{powerstation.fuel_type}</li>
                    <li><em>Technology:</em> #{powerstation.technology}</li>
                    <li><em>Installed Capacity (#{powerstation.units}):</em> #{powerstation.total_capacity}</li>
                    <li><em>State:</em> #{powerstation.state}</li>
                    <li><em>Owned:</em> #{powerstation.owner}</li>
                    <li><em>Commissioned:</em> #{powerstation.commission}</li>
                    <li><em>No. of units:</em> #{powerstation.no_turbines}</li>
                    <li><em>Unit #{powerstation.units}:</em> #{powerstation.turbine_capacity}</li>
                    <li><em>Comments:</em> #{powerstation.comments}</li>
                    <li><em>Latitude:</em> #{powerstation.latitude}</li>
                    <li><em>Longitude:</em> #{powerstation.longitude}</li>
                    <li><em>Source:</em> #{powerstation.reference}</li>
                    <li><em>Status:</em> #{powerstation.status}</li>
                    </ul>
                    </td></tr></table>")
								end
                xml.tag! "LookAt" do
                  xml.longitude powerstation.longitude
                  xml.latitude powerstation.latitude
									xml.altitude 0
									xml.range 5000
									xml.tilt 60
									xml.heading 0
								end
								xml.name powerstation.name
								xml.styleUrl fuel_type
								xml.tag! "Point" do
									xml.coordinates "#{powerstation.longitude},#{powerstation.latitude}"
								end
							end
						end
					end
				end
			end
		end
	end
end