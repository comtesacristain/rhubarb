class Resource < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.resources"
	set_primary_key :resourceno
  set_date_columns :recorddate, :entrydate, :qadate, :lastupdate

	has_many :resource_grades, :class_name => "ResourceGrade",  :foreign_key => :resourceno
  has_many :resource_references, :class_name => "ResourceReference", :foreign_key => :resourceno
  belongs_to :zone, :class_name => "Zone", :foreign_key => :eno
  has_one :deposit, :through => :zone

  has_one :deposit_status, :through => :deposit

  default_scope :order => "recorddate desc"

  scope :recent, where("mgd.resources.recorddate in (select MAX(r.recorddate) from mgd.resources r where r.eno = mgd.resources.eno)")
	
	scope :mineral, lambda { |min| { :include=>:resource_grades, :conditions=> ["mgd.resource_grades.commodid in (:mineral)", {:mineral => min}] } }

  #scope :mineral, joins(:resource_grades) & ResourceGrade.mineral

  scope :zeroed, where({:pvr=>0,:pbr=>0,:ppr=>0,:mrs=>0,:idr=>0,:mid=>0,:ifr=>0,:other=>0})
  
  scope :nonzero, where("(mgd.resources.pvr <> 0 or mgd.resources.pbr <> 0 or mgd.resources.ppr <> 0 or mgd.resources.mrs <> 0 or mgd.resources.idr <> 0 or mgd.resources.mid <> 0 or mgd.resources.ifr <> 0 or mgd.resources.other <> 0)")

  scope :qaed, where(:qa_status_code=>'C')
  scope :not_qaed, where(:qa_status_code=>'U')
  # For coal
  scope :recoverable, :conditions => {:rec_recoverable => 'Y'}
  scope :insitu, :conditions => {:rec_recoverable => 'N'}

  scope :public, :conditions=> "mgd.resources.access_code = 'O' and mgd.resources.qa_status_code = 'C'"

  def identify
    return IdentifiedResourceSet.new(self)
  end

  def zero?
    return pvr==0 && pbr==0 && ppr==0 && mrs==0 && idr==0 && mid==0 && ifr==0 && other==0
  end
  
  def nonzero?
    return pvr!=0 || pbr!=0 || ppr!=0 || mrs!=0 || idr!=0 || mid!=0 || ifr!=0 || other!=0
  end
  
  # def self.mineral(mineral)
    # self.joins(:resource_grades).where(:resource_grades=>{:commodid => mineral}).uniq
  # end
	
	def self.year(year)
	  date = Date.new(year).end_of_year
	  self.date(date)
	end
	
	
	def self.date(date)
	  self.where("mgd.resources.recorddate in (select MAX(r.recorddate) from mgd.resources r where r.eno = mgd.resources.eno and r.recorddate <= ?)", date)
	end
	
	#this
	# deposit.resources & Resource.recent.nonzero.includes(:resource_grades)
	
end
