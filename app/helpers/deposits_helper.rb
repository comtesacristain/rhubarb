module DepositsHelper
  def print_deposit(deposit,xml, visibility_style)
    xml.Cell 'ss:StyleID'=>visibility_style do
      xml.Data deposit.eno, 'ss:Type' => 'Number'
    end
    xml.Cell 'ss:StyleID'=>visibility_style do
      xml.Data deposit.entityid, 'ss:Type' => 'String'
    end
    xml.Cell 'ss:StyleID'=>visibility_style do
      xml.Data deposit.deposit_status.try(:state), 'ss:Type' => 'String'
    end
    xml.Cell 'ss:StyleID'=>visibility_style do
      xml.Data deposit.deposit_status.try(:operating_status), 'ss:Type' => 'String'
    end
    xml.Cell 'ss:StyleID'=>visibility_style do
      xml.Data deposit.commodity_list.try(:commodids), 'ss:Type' => 'String'
    end

    xml.Cell 'ss:StyleID'=>visibility_style do
      xml.Data deposit.try(:longitude), 'ss:Type' => 'Number'
    end
    xml.Cell 'ss:StyleID'=>visibility_style do
      xml.Data deposit.try(:latitude), 'ss:Type' => 'Number'
    end
  end


  ## Builds identified resource CSV for deposits download
  

  def build_resource_csv(resource)
    if resource.empty?
      return Array.new(21)
      
    else
      identified_resources=IdentifiedResourceSet.new(resource)
      if @commodity.class == String
        commodities=[@commodity]
      else
        commodities = @commodity
      end
      economic_row = Array.new
      units_row = Array.new
      resource_row = Array.new
      reserves_row = Array.new
      paramarginal_row = Array.new
      submarginal_row = Array.new
      inferred_row = Array.new

      commodity_row = Array.new
     
      commodities.each do |c|
        
        if c.in?(identified_resources.commodities)
          commodity_row << c
          units_row = [identified_resources.economic[c][:units][:ore], identified_resources.economic[c][:units][:mineral], identified_resources.economic[c][:units][:grade] ]
          ## FIX ABOVE LINE
            
            
          resource_row = [identified_resources.date[:end], identified_resources.material.to_sentence]
          reserves_row = [identified_resources.reserves[c][:ore], identified_resources.reserves[c][:mineral], identified_resources.reserves[c][:grade] ]
          economic_row = [identified_resources.economic[c][:ore], identified_resources.economic[c][:mineral], identified_resources.economic[c][:grade] ]
          paramarginal_row = [identified_resources.paramarginal[c][:ore]  , identified_resources.paramarginal[c][:mineral], identified_resources.paramarginal[c][:grade] ]
          submarginal_row = [identified_resources.submarginal[c][:ore], identified_resources.submarginal[c][:mineral], identified_resources.submarginal[c][:grade] ]
          inferred_row = [identified_resources.inferred[c][:ore], identified_resources.inferred[c][:mineral], identified_resources.inferred[c][:grade] ]
          commodity_row +=  resource_row + units_row + reserves_row + economic_row + paramarginal_row + submarginal_row + inferred_row
        else
          commodity_row += Array.new(21)
        end
      end
      return commodity_row
    end
   
  end
  
  
   ## Builds JORC resource CSV for deposits download
  
  def build_jorc(resources)
    if resources.empty?
      return Array.new
    else
      
      identified_resources=IdentifiedResourceSet.new(resources)
      #TODO Should this be a Hash or Arrays?
      
      case @commodity.class
      when String
        commodities=[@commodity]
      when NilClass
        commodities = identified_resources.commodities
      else
        commodities = @commodity
      end

      
      jorc_row = Array.new

      units=Array.new
      proven=Array.new
      probable = Array.new
      proven_probable = Array.new
      
      measured = Array.new 
      indicated = Array.new 
      measured_indicated = Array.new 
      inferred = Array.new
      other = Array.new

       
      commodities.each do |c|
     
        if c.in?(identified_resources.commodities)
          
          
          
          #TODO Fix this so there is a global units accessor
          jorc_row << identified_resources.date[:start] <<   identified_resources.update << identified_resources.inclusive << c
          
          jorc_row << identified_resources.proven[c][:units][:ore] << identified_resources.proven[c][:units][:mineral] << identified_resources.proven[c][:units][:grade] rescue String.new 
          

          jorc_row << identified_resources.proven[c][:ore] << identified_resources.proven[c][:mineral] << identified_resources.proven[c][:grade] 
          jorc_row << identified_resources.probable[c][:ore] << identified_resources.probable[c][:mineral] << identified_resources.probable[c][:grade]
          jorc_row << identified_resources.proven_probable[c][:ore] << identified_resources.proven_probable[c][:mineral] << identified_resources.proven_probable[c][:grade]

          jorc_row << identified_resources.measured[c][:ore] << identified_resources.measured[c][:mineral] << identified_resources.measured[c][:grade]
          
          jorc_row << identified_resources.indicated[c][:ore] << identified_resources.indicated[c][:mineral] << identified_resources.indicated[c][:grade]
          jorc_row << identified_resources.measured_indicated[c][:ore] << identified_resources.measured_indicated[c][:mineral] << identified_resources.measured_indicated[c][:grade]
          jorc_row << identified_resources.inferred[c][:ore] << identified_resources.inferred[c][:mineral] << identified_resources.inferred[c][:grade]
          
          jorc_row << identified_resources.other[c][:ore] << identified_resources.other[c][:mineral] << identified_resources.other[c][:grade]
          
        end
          #puts commodities
      end
    
       #return units + proven + probable + proven_probable + measured + indicated + measured_indicated + inferred + other
    end
    
      return jorc_row
  end
  
  
 def create_resource_headers
  commodity_headers = Array.new
  deposit_headers = ["ENO", "NAME", "SYNONYMS", "STATE", "OPSTATUS", "LONGITUDE", "LATITUDE", "COMMODIDS"]
  units_headers = ["COMMODID","RECORDDATE","MATERIAL","ORE_UNITS","MINERAL_UNITS","GRADE_UNITS"]
  resource_headers = ["RESERVES_ORE","RESERVES_MINERAL","RESERVES_GRADE","EDR_ORE","EDR_MINERAL","EDR_GRADE","PMR_ORE","PMR_MINERAL","PMR_GRADE","SBM_ORE","SBM_MINERAL","SBM_GRADE","IFR_ORE","IFR_MINERAL","IFR_GRADE"]

  #TODO Fix for coal
  if @commodity.size > 1 
    @commodity.each do |c|
      #TODO Use aliases rather than hardcoded coal commodity codes
      if c.in?(['Cbl','Cbr'])
        commodity_headers += units_headers.map{|uh| "#{c.upcase}_RECOVERABLE_#{uh}"} + resource_headers.map{|rh| "#{c.upcase}_RECOVERABLE_#{rh}"} + units_headers.map{|uh| "#{c.upcase}_INSITU_#{uh}"} + resource_headers.map{|rh| "#{c.upcase}_INSITU_#{rh}"}
      else
        commodity_headers += units_headers.map{|uh| "#{c.upcase}_#{uh}"} + resource_headers.map{|rh| "#{c.upcase}_#{rh}"}
      end

    end
  else
  commodity_headers = units_headers + resource_headers
  end
  return deposit_headers + commodity_headers
end
  
  def calculate_contained_mineral(r,g,u)
    @@unit_codes= Hash[UnitCode.all.map {|un| [un.unitcode,un.unitvalue.to_f]}]
    return r * g * @@unit_codes[u] rescue nil
  end
  

  def print_zone_for_show
    capture_haml do
      options = case 
      when @resource.nil? then {:style=>'null',:text=>'(Empty)'}
      when @resource.zero? then {:style=>'zeroed',:text=>'(Zeroed)'}
      else {:style=>'',:text=>''}
      end
      haml_tag "h4.#{options[:style]}" do
        haml_concat link_to("#{@zone.name} #{options[:text]}",@zone)
      end
    end
  end


  def header_generator
     string_parameters = Hash.new
     string_parameters[:number] = @total_deposits
     
     if params[:status].blank? 
       string_parameters[:status] = "Deposit"
     else
       string_parameters[:status] = params[:status].titleize
     end

     if string_parameters[:number] > 1
       string_parameters[:status]=string_parameters[:status].pluralize
     end
     
     unless params[:commodity].blank?
       commodities= params[:commodity].split(",")
       
       string_parameters[:commodity]="containing #{commodities.map { |c| CommodityType.find(c).commodname}.to_sentence}"
     end
     
     unless params[:state].blank?
       string_parameters[:locality]=params[:state] 
     else
       string_parameters[:locality] = "Australia"
     end
     return "#{string_parameters[:number]} #{string_parameters[:status]} in #{string_parameters[:locality]} #{string_parameters[:commodity]}"
  end
end
