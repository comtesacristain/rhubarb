xml = Builder::XmlMarkup.new
xml.instruct!
xml.tag!("wfs:FeatureCollection",
  "xmlns:gco"=>"http://www.isotc211.org/2005/gco",
  "xmlns:gmd"=>"http://www.isotc211.org/2005/gmd",
  "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema",
  "xmlns:xlink"=>"http://www.w3.org/1999/xlink",
  "xmlns:wfs"=>"http://www.opengis.net/wfs",
  "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
  "xmlns:gsml"=>"urn:cgi:xmlns:CGI:GeoSciML:2.0",
  "xmlns:gml"=>"http://www.opengis.net/gml",
  "xmlns:er"=>"urn:cgi:xmlns:GGIC:EarthResource:1.1") do
  xml.tag!("gml:boundedBy") do
    xml.tag!("gml:Envelope","srsName"=>"EPSG:4283") do
      xml.tag!("gml:pos","srsDimension"=>"2")do
        
      end
      xml.tag!("gml:pos","srsDimension"=>"2")do
        
      end
    end
  end
  xml.tag!("gml:featureMember") do
    for d in @deposits
      xml.tag!("er:Mine","gml:id"=>"mo.mine.#{d.eno}")  do
        xml.tag!("gml:name") do
          xml.text! "urn.cgi.feature.GA.Mine.#{d.eno}"
        end
        xml.tag!("er:occurrence") do
          xml.tag!("er:MiningFeatureOccurrence") do
            xml.tag!("gml:name") do
              xml.text! "urn.cgi.feature.GA.MiningFeatureOccurrence.#{d.eno}"
            end
            xml.tag!("er:observationMethod")do
              xml.tag!("gsml:CGI_TermValue")do
                xml.tag!("gsml:value","codeSpace"=>"http://urn.opengis.net/")do
                  xml.text! "urn:ogc:def:nil:OGC::missing"
                end
              end
            end
            xml.tag!("er:positionalAccuracy")do
              xml.tag!("gsml:CGI_TermValue")do
                xml.tag!("gsml:value","codeSpace"=>"http://urn.opengis.net/")do
                  xml.text! "urn:ogc:def:nil:OGC::missing"
                end
              end
            end
            xml.tag!("er:specification","xlink:href"=>"urn.cgi.feature.GA.Mine.#{d.eno}")
            xml.tag!("er:location") do
              xml.tag!("gml:Point","srsName"=>"EPSG:4283") do
                xml.tag!("gml:pos","srsDimension"=>"2") do
                  xml.text! "#{d.longitude} #{d.latitude}"
                end
              end
            end
          end
        end
        xml.tag!("er:mineName") do
          xml.tag!("er:MineName") do
            xml.tag!("er:isPreferred") do
              xml.text! "1"
            end
            xml.tag!("er:mineName") do
              xml.text! d.name
            end
          end
        end
        xml.tag!("er:status") do
          xml.text! d.synonym.try(:operating_status) || ""
        end
        xml.tag!("er:relatedActivity","xlink:href"=>"urn.cgi.feature.GA.MiningActivity.#{d.eno}")
      end
    end
  end
end