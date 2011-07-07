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

end
