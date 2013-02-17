fuel_types= {"solar"=>"http://www.wikienergy.de/img/wiki_sonne.png","wind"=>"http://www.wikienergy.de/img/wiki_wind.png",
  "hydro"=>"http://www.wikienergy.de/img/wiki_laufwasser.png","geothermal"=>"http://www.wikienergy.de/img/wiki_erdwaerme.png",
  "tidal"=>"http://www.wikienergy.de/img/wiki_welle.png","biomass"=>"http://www.wikienergy.de/img/wiki_biomasse.png",
  "waste"=>"http://www.wikienergy.de/img/wiki_muell.png","other"=>"http://www.wikienergy.de/img/wiki_sonstiges.png"}

statuses =["operating","proposed"]

xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
	xml.tag! "Document" do
		xml.name "Powerstations in Australia (2010)"
		xml.tag! "description" do
			xml.cdata!("Data from the <a href='http://www.ga.gov.au/renewable/'>Department of Environment, Water, Heritage and the Arts</a>")
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
		#TODO Fix folder problem.
		statuses.each do |status|
			xml.tag! "Folder" do
				xml.name status.titleize
				#fuel_types.keys.sort.each do |fuel_type|
					#xml.tag! "Folder" do
						#xml.name fuel_type.titleize
						@powerstations.send(status).each do |powerstation|
							xml.tag! "Placemark" do
								xml.description do
									xml.cdata!("<table><tr><td><img src='http://www.ga.gov.au/renewable/#{powerstation.image_name}' /></td><td width='200px'>
										Name: #{powerstation.name}<br />
										State: #{powerstation.state}<br />
										Owned: #{powerstation.owner}<br />
										Commissioned: #{powerstation.owner}<br />
										Longitude: #{"%3.3f" % powerstation.longitude}<br />
										Latitude: #{"%3.3f" % powerstation.latitude}<br /></td></tr></table>")
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
								#xml.styleUrl fuel_type
								xml.tag! "Point" do
									xml.coordinates "#{powerstation.longitude},#{powerstation.latitude}"
								#end
							#end
						end
					end
				end
			end
		end
	end
end