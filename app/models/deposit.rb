class Deposit < Entity
  attr_reader :province_tokens  
  def self.default_scope
    where(:entity_type => 'MINERAL DEPOSIT')
  end

  has_one :deposit_status, :class_name => "DepositStatus", :foreign_key => :eno

  has_one :commodity_list, :class_name => "CommodityList",  :foreign_key => :idno

  has_many :zones, :class_name => "Zone",  :foreign_key => :parent

  has_many :resources, :through => :zones
  has_many :resource_grades, :through => :resources

  has_many :regrocks, :class_name => "Regrock", :foreign_key => :eno

  has_many :commodities, :class_name => "Commodity",  :foreign_key => :eno

  has_many :deposit_attributes, :class_name => "DepositAttribute",  :foreign_key => :eno

  has_many :weblinks, :class_name => "Weblink", :foreign_key => :eno
  has_many :websites, :through => :weblinks, :class_name => "Website", :foreign_key => :websiteno

  has_many :bloblinks, :class_name => "Bloblink", :foreign_key => :source_no

  # Provinces
  has_many :province_deposits, :class_name => "ProvinceDeposit", :foreign_key => :deposno
  
  
  #accepts_nested_attributes_for :regrocks
  
  has_many :provinces, :through => :province_deposits, :class_name => "Province", :foreign_key => :eno
  
  
  def province_tokens=(ids)
    self.province_ids=ids.split(",")
  end

  #scope :mineral, lambda { |min| { :include=>:commodities, :conditions=> ["mgd.commods.commodid in (?)", min] } }
	
	def self.mineral(mineral)
	  self.includes(:commodities).merge(Commodity.mineral(mineral))
	end
	
	#scope :state, lambda { |s| { :include=>:deposit_status, :conditions=> ["mgd.deposits.state = ?", s] } }
	
	def self.state(state)
	  self.includes(:deposit_status).merge(DepositStatus.state(state))
	end
	
	
	def self.status(status)
    self.includes(:deposit_status).merge(DepositStatus.status(status))
  end
  
	
	#scope :status, lambda { |os| { :include=>:deposit_status, :conditions=> ["mgd.deposits.operating_status = ?", os] } }
  #scope :by_name, lambda { |name| { :include=>:deposit_status, :conditions=> ["UPPER(a.entities.entityid) like UPPER(:name) or UPPER(mgd.deposits.synonyms) like UPPER(:name)",{:name=> "%#{name}%"}] } }

  scope :major, :include=>:commodities, :conditions=> "commorder < 10"
  scope :minor, :include=>:commodities, :conditions=> "commorder >= 9"

  scope :public, :include=>:commodities, :conditions=> "a.entities.access_code = 'O' and a.entities.qa_status_code = 'C'"

  self.per_page = 10

  
  
  
  def regname
    return deposit_attributes.regname.first.try(:valuename)
  end

  def minage_gp
    return deposit_attributes.minage_gp.first.try(:valuename)
  end

	def minsys_gp
    return deposit_attributes.minsys_gp.first.try(:valuename)
  end

	def minsys_sgp
    return deposit_attributes.minsys_sgp.first.try(:valuename)
  end

	def minsys_typ
    return deposit_attributes.minsys_typ.first.try(:valuename)
  end

	def classification
    return deposit_attributes.classification.first.try(:valuename)
  end

	def deposit_type
    return deposit_attributes.deposit_type.first.try(:valuename)
  end

  def atlas_visible?
    return quality_checked? && open_access? && geom?
  end

  def atlas_status?
    deposit_status.atlas_status?
  end

  def quality_checked?
    return qa_status_code == "C"
  end

  def open_access?
    return access_code == "O"
  end

  def confidential?
    return access_code == "C"
  end

  def to_param
    "#{eno}-#{entityid.parameterize}"
  end 
  
  
  def self.by_name(name)
    return self.joins(:deposit_status).where("upper (entityid) like upper('%#{name}%') or upper(synonyms) like upper('%#{name}%')")
  end
  
  #listings
  
  #TODO Put this in Entity model
       
  def self.names(name=nil)
    unless name.nil?
      return self.by_name(name).pluck(:entityid)
    else
      return self.pluck(:entityid)
    end
  end

  
  
end
