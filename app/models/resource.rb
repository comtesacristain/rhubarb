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
	scope :zeroed, where({:pvr=>0,:pbr=>0,:ppr=>0,:mrs=>0,:idr=>0,:mid=>0,:ifr=>0,:other=>0})


  #scope :nonzero, :conditions => "(pvr <> 0 or pbr <> 0 or ppr <> 0 or mrs <> 0 or idr <> 0 or mid <> 0 or ifr <> 0 or other <> 0)"
  scope :nonzero, where("(mgd.resources.pvr <> 0 or mgd.resources.pbr <> 0 or mgd.resources.ppr <> 0 or mgd.resources.mrs <> 0 or mgd.resources.idr <> 0 or mgd.resources.mid <> 0 or mgd.resources.ifr <> 0 or mgd.resources.other <> 0)")

  scope :recoverable, :conditions => {:rec_recoverable => 'Y'}
  scope :insitu, :conditions => {:rec_recoverable => 'N'}

  scope :public, :conditions=> "mgd.resources.access_code = 'O' and mgd.resources.qa_status_code = 'C'"

  

	scope :year , lambda  { |y| {:conditions => ["mgd.resources.recorddate in (select MAX(r.recorddate) from mgd.resources r where r.eno = mgd.resources.eno and r.recorddate <= ?)", y] } }

	scope :mineral, lambda { |min| { :include=>:resource_grades, :conditions=> ["mgd.resource_grades.commodid in (:mineral)", {:mineral => min}] } }

#	def self.grade(commodity, year, options={})
#	  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
#	  year_end = '31-DEC-'+year.to_s
#	  year_start = '01-JAN-'+year.to_s
#	  recorddate = "select MAX(recorddate) from mgd.resources mr
#				where mr.eno = r.eno#" # and mr.resourceno=mrg.resourceno and mrg.commodid = :commodity"
#	  recorddate += " and recorddate <= :date"
#	  sql = "select e1.eno, e1.entityid as deposit_name, e.entityid as zone_name, r.pvr as resource_pvr,
#				r.pbr as resource_pbr, r.ppr as resource_ppr, r.mrs as resource_mrs, r.idr as resource_idr,
#				r.mid as resource_mid, r.ifr as resource_ifr, r.other as resource_other, r.unit_quantity,
#				r.inclusive, r.recorddate, r.material,
#				rg.commodid as commodity, rg.unit_grade, rg.pvr, rg.pbr, rg.ppr, rg.mrs, rg.idr, rg.mid, rg.ifr, rg.other,
#				rg.pvr_class1, rg.pbr_class1, rg.ppr_class1, rg.mrs_class1, rg.idr_class1, rg.mid_class1, rg.ifr_class1, rg.other_class1,
#				rg.pvr_class2, rg.pbr_class2, rg.ppr_class2, rg.mrs_class2, rg.idr_class2, rg.mid_class2, rg.ifr_class2, rg.other_class2,
#				rg.pvr_pcnt1, rg.pbr_pcnt1, rg.ppr_pcnt1, rg.mrs_pcnt1, rg.idr_pcnt1, rg.mid_pcnt1, rg.ifr_pcnt1, rg.other_pcnt1,
#				rg.pvr_pcnt2, rg.pbr_pcnt2, rg.ppr_pcnt2, rg.mrs_pcnt2, rg.idr_pcnt2, rg.mid_pcnt2, rg.ifr_pcnt2, rg.other_pcnt2, ct.conversionfactor
#				from mgd.resources r, mgd.resource_grades rg, a.entities e, a.entities e1, mgd.deposits d, mgd.commodtypes ct
#				where r.resourceno = rg.resourceno and rg.commodid in (:commodity) and e.eno=r.eno and e.parent = e1.eno
#				and ct.commodid = rg.commodid
#				and e1.eno=d.eno
#				and r.recorddate in (#{recorddate})#"
#	  sql += " and d.state = '#{options[:state]}'" if options[:state]
#	  sql += " and e1.eno= '#{options[:eno]}'" if options[:eno]
#    sql += " and r.rec_recoverable = 'Y'" if options[:coal] == 'recoverable'
#    sql += " and r.rec_recoverable = 'N'" if options[:coal] == 'insitu'
#	  Resource.find_by_sql([sql, {:commodity=>commodity,:date=>year_end}])
#	end

  def self.aliased_commodities
	return {'coal'=>['Cbl','Cbr','Coal'],'fluorine'=>['F','Fl','Toz'],'lithium'=>['Li','Li2O'],'magnesite'=>['Mgs','MgO'],'molybdenum'=>['Mo','MoS2'],
		'niobium'=>['Nb','Nb2O5'],'lead_zinc'=>['Pb','Zn'],'platinum_group_elements'=>['Pt','PGE','Pd','Os','Ir','Rh','Ru'],
		'rare_earths'=>['REO','Y2O3','REE'],'tantalum'=>['Ta','Ta2O5'],'tin'=>['Sn','SnO2'],'tungsten'=>['W','WO3'],'uranium'=>['U','U3O8'],
		'vanadium'=>['V','V2O5']}
  end

  def pvr
    self.pvr_before_type_cast
  end

  def pbr
    self.pbr_before_type_cast
  end

  def ppr
    self.ppr_before_type_cast
  end

  def mrs
    self.mrs_before_type_cast
  end

  def idr
    self.idr_before_type_cast
  end

  def mid
    self.mid_before_type_cast
  end

  def ifr
    self.ifr_before_type_cast
  end

  def other
    self.other_before_type_cast
  end


  def identify
    return IdentifiedResourceSet.new(self)
  end


  def zero?
    return pvr==0 && pbr==0 && ppr==0 && mrs==0 && idr==0 && mid==0 && ifr==0 && other==0
  end
	
end
