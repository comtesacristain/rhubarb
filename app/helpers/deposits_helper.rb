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
      return Array.new(20)
    else
    identified_resources=IdentifiedResourceSet.new(resource)
    resource_row = Array.new
    units_row = Array.new
    reserves_row = Array.new
    economic_row = Array.new
    paramarginal_row = Array.new
    submarginal_row = Array.new
    inferred_row = Array.new
    
    ## FIX NEXT LINE
    units_row << identified_resources.economic[:units][:ore] << identified_resources.economic[:units][:mineral] << identified_resources.economic[:units][:grade] rescue String.new
    ## FIX ABOVE LINE
    resource_row << identified_resources.date[:end] << identified_resources.material.to_sentence
    reserves_row << identified_resources.reserves[:ore] << identified_resources.reserves[:mineral] << identified_resources.reserves[:grade]
    economic_row << identified_resources.economic[:ore] << identified_resources.economic[:mineral] << identified_resources.economic[:grade]
    paramarginal_row << identified_resources.paramarginal[:ore] << identified_resources.paramarginal[:mineral] << identified_resources.paramarginal[:grade]
    submarginal_row << identified_resources.submarginal[:ore] << identified_resources.submarginal[:mineral] << identified_resources.submarginal[:grade]
    inferred_row << identified_resources.inferred[:ore] << identified_resources.inferred[:mineral] << identified_resources.inferred[:grade]
    return units_row + resource_row + reserves_row + economic_row + paramarginal_row + submarginal_row + inferred_row
    end
  end

end
