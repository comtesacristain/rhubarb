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
  
  def build_jorc_csv(resource,grade)
    codes = ["pvr","pbr","ppr","mrs","idr","mid","ifr","other"]
    jorc = Array.new
    @unit_grade=grade.unit_grade
    jorc <<  resource.recorddate << resource.unit_quantity << @unit_grade << grade.commodid << resource.inclusive
    codes.each do |code|
      @resource = resource.send(code)
      @grade = grade.send(code) 
      contained_mineral = calculate_contained_mineral
      jorc << @resource << @grade << contained_mineral
    end
    return jorc
  end
  
  def calculate_contained_mineral
    @@unit_codes= Hash[UnitCode.all.map {|u| [u.unitcode,u.unitvalue.to_f]}]
    return @resource * @grade * @@unit_codes[@unit_grade] rescue nil
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


end
