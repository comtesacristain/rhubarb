class Zone < Entity
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :parent
	has_many :resources, :class_name => "Resource",  :foreign_key => :eno

  has_many :resource_grades, :through => :resources

  has_one :deposit_status, :class_name => "DepositStatus", :primary_key=>:parent, :foreign_key => :eno
  has_one :status, :class_name => "DepositStatus", :primary_key=>:eno, :foreign_key => :eno
  scope :state, lambda { |s| { :include=>:deposit_status, :conditions=> ["mgd.deposits.state = ?", s] } }


  self.sti_name = "MINERALISED ZONE"

  scope :public, :conditions=> "a.entities.access_code = 'O'"

end
