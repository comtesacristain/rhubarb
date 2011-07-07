class Zone < Entity

	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :parent
	has_many :resources, :class_name => "Resource",  :foreign_key => :eno

  #has_many :resource_grades, :through=> :resource

	default_scope :conditions => {:entity_type => 'MINERALISED ZONE'}

  scope :public, :conditions=> "a.entities.access_code = 'O'"

end
