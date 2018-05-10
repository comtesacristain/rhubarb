class Province < Entity
  def self.sti_name
    "PROVINCE"
  end
  
  has_one :province_status, :class_name => "ProvinceStatus", :foreign_key => :eno

  #Province parent/child

  belongs_to :parent_province, :class_name => "Province", :foreign_key =>:parent
  has_many :provinces, :class_name => "Province", :foreign_key =>:parent

  #Province relations
  has_many :province_relations,  :foreign_key => :eno
  has_many :relations, :class_name => "Province", :through => :province_relations

  #Province relation types
  #TODO: Investigate polymorhpic types
  has_many :adjoining_provinces, -> {where province: {provreltype: 'adjoins'} }, :class_name => "Province", :through => :province_relations, :source =>:relation
  has_many :overlying_provinces, -> {where province: {provreltype: 'overlies'} }, :class_name => "Province", :through => :province_relations, :source =>:relation
  has_many :underlying_provinces, -> {where province: {provreltype: 'underlies'} }, :class_name => "Province", :through => :province_relations, :source =>:relation
  has_many :intruding_provinces, -> {where province: {provreltype: 'intrudes'} }, :class_name => "Province", :through => :province_relations, :source =>:relation
  has_many :interfingering_provinces, -> {where province: {provreltype: 'interfingers'} }, :class_name => "Province", :through => :province_relations, :source =>:relation

  

  # Deposits
  has_many :province_deposits, :class_name => "ProvinceDeposit", :foreign_key => :eno
  has_many :deposits, :through => :province_deposits

  # Commodities
  has_many :commodities, :through => :deposits

  # scope :by_name, lambda { |name| { :conditions=> ["UPPER(a.entities.entityid) like UPPER(:name)",{:name=> "%#{name}%"}] } }
  
  def self.by_name(name)
    return self.where("upper (entityid) like upper('%#{name}%')")
  end 
  
  # Key Lookups
  def self.find_with_deposit_as_keys(id=nil)
    #TODO where instead of find is dangerous when number of things is over 1000
    unless id.nil?
      self.where(:eno=>id).collect{|p| {:id=>p.eno,:name=>p.entityid}}
    else
      self.where(:eno=>ProvinceDeposit.uniq.pluck(:eno)).collect{|p| {:id=>p.eno,:name=>p.entityid}}
    end
    
  end 
  
  
  
  
end
