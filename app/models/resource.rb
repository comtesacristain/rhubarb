class Resource < ActiveRecord::Base
  self.table_name = "mgd.resources"
  self.primary_key = :resourceno
  
  set_date_columns :recorddate, :entrydate, :qadate, :lastupdate

  default_scope { order(:recorddate) } 

  has_many :resource_grades, :class_name => "ResourceGrade",  :foreign_key => :resourceno
  has_many :resource_references, :class_name => "ResourceReference", :foreign_key => :resourceno
  
  has_many :references, :through => :resource_references
  
  belongs_to :zone, :class_name => "Zone", :foreign_key => :eno
  has_one :deposit, :through => :zone

  has_one :deposit_status, :through => :deposit

  #default_scope :order => "recorddate desc"

  scope :recent, -> {
    where("mgd.resources.recorddate in (select MAX(r.recorddate) from mgd.resources r where r.eno = mgd.resources.eno)")
	}
  
	#scope :mineral, lambda { |min| { :include=>:resource_grades, :conditions=> ["mgd.resource_grades.commodid in (:mineral)", {:mineral => min}] } }

  def self.mineral(mineral)
    return includes(:resource_grades).where(resource_grades:{commodid: mineral}).references(:resource_grades)
  end

  #scope :mineral, joins(:resource_grades) & ResourceGrade.mineral

  scope :zeroed, -> {where({:pvr=>0,:pbr=>0,:ppr=>0,:mrs=>0,:idr=>0,:mid=>0,:ifr=>0,:other=>0}) }
  
  
  scope :nonzero, -> { where("(mgd.resources.pvr <> 0 or mgd.resources.pbr <> 0 or mgd.resources.ppr <> 0 or mgd.resources.mrs <> 0 or mgd.resources.idr <> 0 or mgd.resources.mid <> 0 or mgd.resources.ifr <> 0 or mgd.resources.other <> 0)") }

=begin
  TODO Arel may provide a way to implement this as the complement of 'zeroed'
  scope :nonzero, -> {
    where Resource.arel_table[:pvr].or(Resource.arel_table[:ppr])
  }
=end
  scope :qaed, -> { where(:qa_status_code=>'C') }
  scope :not_qaed, -> { where(:qa_status_code=>'U') }
  # For coal
  scope :recoverable, -> { where(:rec_recoverable => 'Y') }
  scope :insitu, -> { where(:rec_recoverable => 'N') }
  
  #TODO: Change all instances of public to published
  scope :published, -> {
    where( "mgd.resources.access_code = 'O' and mgd.resources.qa_status_code = 'C'")
  }

  def identify
    return IdentifiedResourceSet.new(self)
  end

  def zero?
    return pvr==0 && pbr==0 && ppr==0 && mrs==0 && idr==0 && mid==0 && ifr==0 && other==0
  end
  
  # TODO Implement below as !zero?
  def nonzero?
    return !zero?
    #return pvr!=0 || pbr!=0 || ppr!=0 || mrs!=0 || idr!=0 || mid!=0 || ifr!=0 || other!=0
  end
  
  # def self.mineral(mineral)
    # self.joins(:resource_grades).where(:resource_grades=>{:commodid => mineral}).uniq
  # end

  # TODO Change to have user lookup in different model
  def self.entered_by(name)
    if Resource.users.keys.include?(name)
      usernames=Resource.users[name]
    else
      usernames=name
    end
    where(:enteredby=>usernames)
  end

  def self.entry_date_range(range)
    self.where(:entrydate=>range)
  end
	
	def self.year(year)
	  date = Date.new(year).end_of_year
	  self.date(date)
	end
	
	
	def self.date(date)
	  self.where("mgd.resources.recorddate in (select MAX(r.recorddate) from mgd.resources r where r.eno = mgd.resources.eno and r.recorddate <= ?)", date)
	end
	
	#this
	# deposit.resources & Resource.recent.nonzero.includes(:resource_grades)
	
	def current?
	  return current_r == "N" ? false : true 
	end
  #TODO This should not be in the Resource model. Try lookups or similar.
  def self.users
    return {"DaisySummerfield"=>["DSUMMERFIELD","U01086"], "MichaelSexton"=>"MSEXTON1",
		"KeithPorritt"=>"KPORRITT", "AllisonBritt"=>["ABRITT","U87263"], "RoyTowner"=>["RTOWNER","U76749"], "PaulKay"=>["PKAY","U32129"],
		"AlanWhitaker" => ["AWHITAKE"]}
  end

end
