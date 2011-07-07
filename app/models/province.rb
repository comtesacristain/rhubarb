class Province < Entity


  default_scope :conditions => "entity_type = 'PROVINCE'", :order => "entityid"

	has_many :province_deposits, :class_name => "ProvinceDeposit", :foreign_key => :eno
  has_one :province_attribute, :class_name => "ProvinceAttribute", :foreign_key => :eno

  scope :by_name, lambda { |name| { :conditions=> ["UPPER(a.entities.entityid) like UPPER(:name)",{:name=> "%#{name}%"}] } }
end
