require 'open-uri'
require 'cgi'
pdf.font "Helvetica", :size => 10


@deposits.each do |deposit|
  pdf.text "#{deposit.name}", :size => 30, :style => :bold, :spacing => 4, :align =>:center
  pdf.text "#{deposit.deposit_status.try(:synonyms)}", :spacing => 16, :style => :italic, :align =>:center
  pdf.table ([["State", "#{deposit.deposit_status.try(:state)}"],
      ["Commodities", "#{deposit.commodity_list.try(:commodids)}"],
      ["Commodity Names", "#{deposit.commodity_list.try(:commodnames)}"],
      ["Operating Status", "#{deposit.deposit_status.try(:operating_status).titleize}"]],
    :cell_style => { :padding => 12, :inline_format => true },
    :width => pdf.bounds.width)
  

  escaped_page = CGI::escape("")
  url = "http://maps.google.com/maps/api/staticmap?center=#{deposit.latitude},#{deposit.longitude}&zoom=14&size=300x300&maptype=hybrid&sensor=false"
  pdf.image open(url,
      "Accept"=>"image/png",
      "User-Agent" =>"Mozilla/5.0") rescue nil
 # pdf.text "#{ENV['http_proxy']}"
  zones = deposit.zones
  unless zones.length == 0
    pdf.text "Reserves and resources"
    dead_zones = Array.new
    zones.each do |zone|
      resource = zone.resources.recent.nonzero.first
      if resource.nil?
        dead_zones << zone
      else
        pdf.text "#{zone.name}", :size => 16
        pdf.text "#{resource.recorddate.to_formatted_s(:long)}"
        resource.resource_references.each do |rr|
          pdf.text "#{rr.reference.source}, #{rr.reference.year}, #{rr.reference.title}"
        end
      end
    end
  end

  pdf.start_new_page
end

#require "open-uri"
#
#
#  Prawn::Document.generate("test.pdf") do
#    image open("http://maps.google.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=12&size=400x400&sensor=false")
#  end
