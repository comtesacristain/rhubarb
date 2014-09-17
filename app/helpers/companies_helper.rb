module CompaniesHelper
  def company_commodities(company)
    begin 
      deposits = company.deposits.joins(:commodities)
	rescue
	  return
	end
	begin
	  return deposits.map {|y| y.commodities.collect(&:commodid)}.flatten.uniq.to_sentence
	rescue
	  return
	end
  end
end
