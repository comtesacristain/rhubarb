xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.Workbook({
    'xmlns'      => "urn:schemas-microsoft-com:office:spreadsheet",
    'xmlns:o'    => "urn:schemas-microsoft-com:office:office",
    'xmlns:x'    => "urn:schemas-microsoft-com:office:excel",
    'xmlns:html' => "http://www.w3.org/TR/REC-html40",
    'xmlns:ss'   => "urn:schemas-microsoft-com:office:spreadsheet"
  }) do

  xml.Styles do
    xml.Style 'ss:ID' => 'Default', 'ss:Name' => 'Normal' do
      xml.Alignment 'ss:Vertical' => 'Bottom'
      xml.Borders
      xml.Font 'ss:FontName' => 'Arial'
      xml.Interior
      xml.NumberFormat
      xml.Protection
    end
    xml.Style 'ss:ID' => 'Header' do
      xml.Alignment 'ss:Vertical' => 'Bottom', 'ss:Horizontal'=>"Center"
      xml.Borders
      xml.Font 'ss:FontName' => 'Arial', 'ss:Bold' => 1
      xml.Interior
      xml.NumberFormat
      xml.Protection
    end
    xml.Style 'ss:ID' => 'invisible' do
      xml.Alignment 'ss:Vertical' => 'Bottom'
      xml.Borders
      xml.Font 'ss:FontName' => 'Arial'
      xml.Interior 'ss:Color' => '#ffc0cb', 'ss:Pattern' => 'Solid'
      xml.NumberFormat
      xml.Protection
    end
  end


  xml.Worksheet 'ss:Name' => 'Quality Check' do
    xml.Table 'ss:DefaultColumnWidth'=>100 do
      xml.Column 
      xml.Column
      xml.Column
      xml.Column
      xml.Column
      xml.Column 
      xml.Column 
      xml.Column
      xml.Column
      xml.Column
      xml.Column
      xml.Column
      xml.Column
      xml.Column
      xml.Column
      xml.Column
      # Header
      xml.Row do
        xml.Cell 'ss:StyleID'=>'Header' do
          xml.Data 'ENO', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID'=>'Header' do
          xml.Data 'Name', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID'=>'Header' do
          xml.Data 'State', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID'=>'Header' do
          xml.Data 'Operating Status', 'ss:Type' => 'String'
        end
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Commodities', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Longitude', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Latitude', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Atlas Visible', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Zone name', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Zone longitude', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Zone latitude', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Zone Commodities', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Resources', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Resources visible', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Resource date', 'ss:Type' => 'String' }
        xml.Cell('ss:StyleID'=>'Header') { xml.Data 'Source', 'ss:Type' => 'String' }
      end

      # Rows
      for deposit in @deposits
        if deposit.qa_status_code == "U" or deposit.access_code !="O" or deposit.geom == nil or !DepositStatus.atlas_statuses.include?(deposit.deposit_status.operating_status)
          atlas_visible = false
          visibility_style = 'invisible'
        else
          visibility_style ='Default'
          atlas_visible = true
        end
        zones = deposit.zones
        if zones.length > 0
          zones.each do |z|
            xml.Row  do
              print_deposit(deposit,xml,visibility_style)
              xml.Cell 'ss:StyleID'=>visibility_style do
                xml.Data atlas_visible ? 'Yes' : 'No', 'ss:Type' => 'String'
              end
              latest_resource =  z.resources.last
              resource_visibility_style = 'Default'
              if latest_resource.try(:pvr).to_i == 0 and  latest_resource.try(:pbr).to_i == 0 and latest_resource.try(:ppr).to_i == 0 and latest_resource.try(:mrs).to_i == 0 and latest_resource.try(:idr).to_i == 0 and latest_resource.try(:mid).to_i == 0 and latest_resource.try(:ifr).to_i == 0 and latest_resource.try(:other).to_i == 0
                zeroed = true
              else
                zeroed = false
              end
              if latest_resource.nil?  or latest_resource.try(:qa_status_code) =='U' or latest_resource.try(:access_code) =='C'
                resources_visible = false
                resource_visibility_style = 'invisible'
              else
                resources_visible = true
                resource_visibility_style = 'Default'
              end
              xml.Cell 'ss:StyleID'=> resource_visibility_style do
                xml.Data z.entityid, 'ss:Type' => 'String'
              end
              xml.Cell 'ss:StyleID'=> resource_visibility_style do
                xml.Data z.try(:longitude), 'ss:Type' => 'Number'
              end
              xml.Cell 'ss:StyleID'=> resource_visibility_style do
                xml.Data z.try(:latitude), 'ss:Type' => 'Number'
              end
              xml.Cell 'ss:StyleID'=> resource_visibility_style do
                unless latest_resource.nil?
                  zone_commods=String.new
                  latest_resource.resource_grades.each do |grade|
                    zone_commods << grade.commodid + " "
                  end
                  xml.Data zone_commods, 'ss:Type' => 'String'
                end
              end
              if latest_resource.nil? 
                r = 'No'
              elsif zeroed
                r = 'Zeroed'
              else
                r= 'Yes'
              end
              xml.Cell 'ss:StyleID'=> resource_visibility_style do
                xml.Data r, 'ss:Type' => 'String'
              end
              xml.Cell 'ss:StyleID'=> resource_visibility_style do
                xml.Data resources_visible ? 'Yes' : 'No', 'ss:Type' => 'String'
              end
              xml.Cell 'ss:StyleID'=> resource_visibility_style do
                xml.Data latest_resource.try(:recorddate), 'ss:Type' => 'String'
              end
              xml.Cell 'ss:StyleID'=> resource_visibility_style do
                resource_reference = latest_resource.try(:resource_references)
                unless resource_reference == nil
                  source = resource_reference.first.try(:reference).try(:source)
                  xml.Data source, 'ss:Type' => 'String'
                end
              end
            end
          end
        else
          xml.Row 'ss:StyleID'=>visibility_style  do
            print_deposit(deposit,xml,visibility_style)
            xml.Cell { xml.Data atlas_visible ? 'Yes' : 'No', 'ss:Type' => 'String' }
          end
        end
      end
    end
  end
end