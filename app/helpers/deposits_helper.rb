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
          commodity_row +=  units_row + resource_row + reserves_row + economic_row + paramarginal_row + submarginal_row + inferred_row
        else
          commodity_row += Array.new(21)
        end
      end
      return commodity_row
    end
    
    #    if resource.empty?
    #      return Array.new(20)
    #    else
    #      identified_resources=IdentifiedResourceSet.new(resource)
    #      resource_row = Array.new
    #      units_row = Array.new
    #      reserves_row = Array.new
    #      economic_row = Array.new
    #      paramarginal_row = Array.new
    #      submarginal_row = Array.new
    #      inferred_row = Array.new
    #    
    #      if @commodity.class == String
    #        @commodity=[@commodity]
    #      end
    #      @commodity.each do |c|
    #         ## FIX NEXT LINE
    #        units_row << identified_resources.economic[c][:units][:ore] << identified_resources.economic[c][:units][:mineral] << identified_resources.economic[c][:units][:grade] rescue String.new
    #        ## FIX ABOVE LINE
    #        
    #        
    #        resource_row << identified_resources.date[:end] << identified_resources.material.to_sentence
    #        reserves_row << identified_resources.reserves[c][:ore] rescue String.new << identified_resources.reserves[c][:mineral] rescue String.new << identified_resources.reserves[c][:grade] rescue String.new
    #        economic_row << identified_resources.economic[c][:ore] rescue String.new << identified_resources.economic[c][:mineral] rescue String.new << identified_resources.economic[c][:grade] rescue String.new
    #        paramarginal_row << identified_resources.paramarginal[c][:ore] rescue String.new << identified_resources.paramarginal[c][:mineral] rescue String.new << identified_resources.paramarginal[c][:grade] rescue String.new
    #        submarginal_row << identified_resources.submarginal[c][:ore]  rescue String.new<< identified_resources.submarginal[c][:mineral] rescue String.new<< identified_resources.submarginal[c][:grade] rescue String.new
    #        inferred_row << identified_resources.inferred[c][:ore] rescue String.new<< identified_resources.inferred[c][:mineral] rescue String.new << identified_resources.inferred[c][:grade] rescue String.new
    #      end
    #      return units_row + resource_row + reserves_row + economic_row + paramarginal_row + submarginal_row + inferred_row
    #    end
  end
  
  
  def build_jorc(resources)
    if resources.empty?
      return Array.new
    else
      if @commodity.class == String
        commodities=[@commodity]
      else
        commodities = @commodity
      end
      identified_resources=IdentifiedResourceSet.new(resources)
      #TODO Should this be a Hash or Arrays?
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
          units << identified_resources.proven[c][:units][:ore] << identified_resources.proven[c][:units][:mineral] << identified_resources.proven[c][:units][:grade] rescue String.new
          proven << identified_resources.proven[c][:ore] << identified_resources.proven[c][:mineral] << identified_resources.proven[c][:grade] 
          probable << identified_resources.probable[c][:ore] << identified_resources.probable[c][:mineral] << identified_resources.probable[c][:grade]
          proven_probable << identified_resources.proven_probable[c][:ore] << identified_resources.proven_probable[c][:mineral] << identified_resources.proven_probable[c][:grade]
          
          measured << identified_resources.measured[c][:ore] << identified_resources.measured[c][:mineral] << identified_resources.measured[c][:grade]
          
          indicated << identified_resources.indicated[c][:ore] << identified_resources.indicated[c][:mineral] << identified_resources.indicated[c][:grade]
          measured_indicated << identified_resources.measured_indicated[c][:ore] << identified_resources.measured_indicated[c][:mineral] << identified_resources.measured_indicated[c][:grade]
          inferred << identified_resources.inferred[c][:ore] << identified_resources.inferred[c][:mineral] << identified_resources.inferred[c][:grade]
          
          other << identified_resources.other[c][:ore] << identified_resources.other[c][:mineral] << identified_resources.other[c][:grade]
          
        end
        return units + proven + probable + proven_probable + measured + indicated + measured_indicated + inferred + other
      end
      
    end
    
    
  end
  
  
 def create_resource_headers
  commodity_headers = Array.new
  deposit_headers = ["ENO", "NAME", "SYNONYMS", "STATE", "OPSTATUS", "LONGITUDE", "LATITUDE", "COMMODIDS"]
  units_headers = ["COMMODID","ORE_UNITS","MINERAL_UNITS","GRADE_UNITS"]
  resource_headers = ["RECORDDATE","MATERIAL","RESERVES_ORE","RESERVES_MINERAL","RESERVES_GRADE","EDR_ORE","EDR_MINERAL","EDR_GRADE","PMR_ORE","PMR_MINERAL","PMR_GRADE","SBM_ORE","SBM_MINERAL","SBM_GRADE","IFR_ORE","IFR_MINERAL","IFR_GRADE"]

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


  def data_quality_check_header
     string_parameters = Hash.new
     string_parameters[:number] = @total_deposits
     
     unless @status.blank? 
       string_parameters[:status] = "Deposit"
     else
       string_parameters[:status] = @status.upcase
     end

     if string_parameters[:number] > 1
       string_parameters[:status]=string_parameters[:status].pluralize
     end
     
     
     string_parameters[:state] = "Australia"
     return "#{string_parameters[:number]} #{string_parameters[:status]} in #{string_parameters[:location]}"
  end
end
