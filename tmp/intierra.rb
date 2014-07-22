require 'csv'
#require 'app/models/deposits.rb'




def parse_csv(file)
  parsed_csv = Hash.new
  csv=CSV.read(file)
  data_block=Array.new
  csv.each do |row| 
    first_column = row.first
    if !first_column.nil?
      case first_column
      when "CRITERIA FOR SEARCH RESULTS:"		  
        parsed_csv[:header] = Array.new
        data_block= parsed_csv[:header]
      when "ID"		  
        parsed_csv[:deposits] = Array.new
        data_block=parsed_csv[:deposits]
      when "Reserves/Resource"		  
        parsed_csv[:resources] =Array.new
        data_block=parsed_csv[:resources]
      when "Reserves/Resource Detail with Classification"
        parsed_csv[:classifications] =Array.new
        data_block=parsed_csv[:classifications]
      end
      data_block << row 
    end
  end
  return parsed_csv
end

def parse_deposits(block)
  keys = [:id, :parent, :name, :propertyno, :latitude, :longitude, :status, :owner]
   indices=[0,1,2,3,4,6,8,9]
  key_pairs = keys.zip(indices)
  i=1  
  deposits = Array.new
  while (i < ((block.size)-1))
    row=block[i]
    deposits << Hash[key_pairs.map {|kp| [ kp[0] , row[kp[1]]] } ]
    i+=1
  end
  return deposits
end
csv_file='./tmp/au_example.csv'
data=parse_csv(csv_file)
data[:deposits]=parse_deposits(data[:deposits])

#puts data
