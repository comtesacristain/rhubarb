xml.tag! "Style", :id => "operating mine" do
  xml.tag! "IconStyle" do
    xml.scale 0.4
    xml.tag! "Icon" do
      xml.href  "#{root_url}assets/red-circle.png"
    end
    xml.outline 0
  end
end
xml.tag! "Style", :id => "mineral deposit" do
  xml.tag! "IconStyle" do
    xml.scale 0.4
    xml.tag! "Icon" do
      xml.href "#{root_url}assets/yellow-circle.png"
    end
    xml.outline 0
  end
end
xml.tag! "Style", :id => "historic mine" do
  xml.tag! "IconStyle" do
    xml.scale 0.4
    xml.tag! "Icon" do
      xml.href "#{root_url}assets/green-circle.png"
    end
    xml.outline 0
  end
end
xml.tag! "Style", :id => "historic mine with resources" do
  xml.tag! "IconStyle" do
    xml.scale 0.4
    xml.tag! "Icon" do
      xml.href "#{root_url}assets/orange-circle.png"
    end
    xml.outline 0
  end
end