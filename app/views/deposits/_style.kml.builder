domain='lws-60603:3000'
xml.tag! "Style", :id => "operating mine" do
  xml.tag! "IconStyle" do
    xml.scale 0.4
    xml.tag! "Icon" do
      xml.href "http://#{domain}/images/red-circle.png"
    end
    xml.outline 0
  end
end
xml.tag! "Style", :id => "mineral deposit" do
  xml.tag! "IconStyle" do
    xml.scale 0.4
    xml.tag! "Icon" do
      xml.href "http://#{domain}/images/yellow-circle.png"
    end
    xml.outline 0
  end
end
xml.tag! "Style", :id => "historic mine" do
  xml.tag! "IconStyle" do
    xml.scale 0.4
    xml.tag! "Icon" do
      xml.href "http://#{domain}/images/green-circle.png"
    end
    xml.outline 0
  end
end