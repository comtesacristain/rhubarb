
resources = Resource.where(enteredby:"U32129",qa_status_code:"U")
resources.each do |resource|
  if resource.recorddate >= resource.entrydate
    comments = resource.remark
    date_regex =  /[0-9]{1,2}([0-9]|[a-zA-Z])[a-zA-Z]{2}[0-9]{2,4}/
    dates = date_regex.match(comments)
    if dates.nil? 
      puts "For resource #{resource.resourceno}, the following comment has no date in it:\n"
      puts comments
    else
      puts "For resource #{resource.resourceno}, the following comment has a date in it:\n"
      puts comments
    end
  end
end