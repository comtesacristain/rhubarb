xml.kml(:xmlns => "http://earth.google.com/kml/2.2") do
  xml.tag! "Document" do
    xml << render(:partial => 'deposits/style')
    xml << render(:partial => 'deposits/deposits')
  end
end