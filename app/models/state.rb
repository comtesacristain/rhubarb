class State < ActiveRecord::Base
  #TODO set relation with DepositStatus
  set_table_name "a.states"
  set_primary_key :stateid

  def self.by_name(name)
     self.where("upper(statename) like ?","%#{name.upcase}%")
  end

  def self.find_as_keys(id=nil)
    unless id.nil?
      return self.where(:stateid=>id).collect{|s|{:id=>s.stateid,:name=>s.statename}}
    else
      return self.all.collect{|s|{:id=>s.stateid,:name=>s.statename}}
    end
     
  end

end
