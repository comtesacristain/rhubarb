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
      # Header
      xml.Row do
        xml.Cell 'ss:StyleID'=>'Header' do
          xml.Data 'REFID', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID'=>'Header' do
          xml.Data 'Title', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID'=>'Header' do
          xml.Data 'Source', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID'=>'Header' do
          xml.Data 'Authors', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID'=>'Header' do
          xml.Data 'Year', 'ss:Type' => 'String'
        end
      end

      # Rows
      for reference in @references do
        xml.Row do
          xml.Cell 'ss:StyleID'=>'Default' do
            xml.Data reference.refid, 'ss:Type' => 'Number'
          end
          xml.Cell 'ss:StyleID'=>'Default' do
            xml.Data reference.title, 'ss:Type' => 'String'
          end
          xml.Cell 'ss:StyleID'=>'Default' do
            xml.Data reference.source, 'ss:Type' => 'String'
          end
          authors = Array.new
          for author in reference.authors do
            authors << author.author
          end
          xml.Cell 'ss:StyleID'=>'Default' do
            xml.Data authors.to_sentence, 'ss:Type' => 'String'
          end
          xml.Cell 'ss:StyleID'=>'Default' do
            xml.Data reference.year, 'ss:Type' => 'Number'
          end
        end
      end
    end
  end
end