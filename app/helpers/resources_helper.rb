module ResourcesHelper
  def aimr_table_cells (commodity, style, link)
    concat(raw("<tr>"))
    if link==true
      concat(raw("<td class='#{style}'>#{link_to commodity.keys.first, url_for(:action=>:state, :year=>params[:year], :commodity=>commodity.values.first)}</td>"))
    else
      concat(raw("<td class='#{style}'>#{commodity.keys.first}</td>"))
    end
    concat(raw("<td class='#{style}' id='#{commodity.values.first.try(:downcase)}_unit'></td>"))
    concat(raw("<td class='#{style}' id='#{commodity.values.first.try(:downcase)}_edr'></td>"))
    concat(raw("<td class='#{style}' id='#{commodity.values.first.try(:downcase)}_dmp'></td>"))
    concat(raw("<td class='#{style}' id='#{commodity.values.first.try(:downcase)}_dms'></td>"))
    concat(raw("<td class='#{style}' id='#{commodity.values.first.try(:downcase)}_ifr'></td>"))
    concat(raw("<td class='#{style}'></td>"))
    concat(raw("<td class='#{style}'></td>"))
    concat(raw("<td class='#{style}'></td>"))
    concat(raw("<td class='#{style}'></td>"))
    concat(raw("<td class='#{style}'></td>"))
    concat(raw("</tr>"))
  end

  def aimr_title(state, year)
    unless year.to_i == Date.today.year
      raw("Australia's resources of major minerals and world figures as at December&nbsp;31,&nbsp;#{year}")
    else
      raw("Australia's resources of major minerals and world figures as at #{Date.today.to_formatted_s(:long)}")
    end
  end
  
end
