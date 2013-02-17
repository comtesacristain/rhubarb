class Province < Entity
  def self.default_scope
    where(:entity_type => 'PROVINCE').merge(super)
  end

  has_one :province_status, :class_name => "ProvinceStatus", :foreign_key => :eno

  #Province parent/child

  belongs_to :parent_province, :class_name => "Province", :foreign_key =>:parent
  has_many :provinces, :class_name => "Province", :foreign_key =>:parent

  #Province relations
  has_many :province_relations,  :foreign_key => :eno
  has_many :relations, :class_name => "Province", :through => :province_relations

  #Province relation types
  has_many :adjoining_provinces,  :class_name => "Province", :through => :province_relations, :source =>:relation, :conditions => ["provreltype = 'adjoins'"]
  has_many :overlying_provinces,  :class_name => "Province", :through => :province_relations, :source =>:relation, :conditions => ["provreltype = 'overlies'"]
  has_many :underlying_provinces,  :class_name => "Province", :through => :province_relations, :source =>:relation, :conditions => ["provreltype = 'underlies'"]
  has_many :intruding_provinces,  :class_name => "Province", :through => :province_relations, :source =>:relation, :conditions => ["provreltype = 'intrudes'"]
  has_many :interfingering_provinces,  :class_name => "Province", :through => :province_relations, :source =>:relation, :conditions => ["provreltype = 'interfingers'"]

  

  # Deposits
  has_many :province_deposits, :class_name => "ProvinceDeposit", :foreign_key => :eno
  has_many :deposits, :through => :province_deposits

  # Commodities
  has_many :commodities, :through => :deposits

  scope :by_name, lambda { |name| { :conditions=> ["UPPER(a.entities.entityid) like UPPER(:name)",{:name=> "%#{name}%"}] } }
  
  
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
