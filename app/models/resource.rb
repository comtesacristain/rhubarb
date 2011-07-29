class Resource < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.resources"
	set_primary_key :resourceno
	has_many :resource_grades, :class_name => "ResourceGrade",  :foreign_key => "resourceno"

  belongs_to :zone, :class_name => "Zone", :foreign_key => :eno
  has_one :deposit, :through => :zone

  
  has_many :resource_references, :class_name => "ResourceReference", :foreign_key => :resourceno

  set_date_columns :recorddate, :entrydate, :qadate, :lastupdate


	scope :recent, where("recorddate in (select MAX(r.recorddate) from mgd.resources r where r.eno = mgd.resources.eno)")
	scope :nonzero, :conditions => "(pvr <> 0 or pbr <> 0 or ppr <> 0 or mrs <> 0 or idr <> 0 or mid <> 0 or ifr <> 0 or other <> 0)"
  scope :recoverable, :conditions => {:rec_recoverable => 'Y'}
  scope :insitu, :conditions => {:rec_recoverable => 'Y'}
  scope :public, :conditions=> "mgd.resources.access_code = 'O' and mgd.resources.qa_status_code = 'C'"

  scope :zeroed, :conditions => "(pvr = 0 and pbr = 0 and ppr = 0 and mrs = 0 and idr = 0 and mid = 0 and ifr = 0 and other = 0)"

	scope :year , lambda  { |y| {:conditions => ["recorddate in (select MAX(r.recorddate) from mgd.resources r where r.eno = mgd.resources.eno and recorddate <= ?)", y] } }

	scope :mineral, lambda { |min| { :include=>:resource_grades, :conditions=> ["mgd.resource_grades.commodid in (:mineral)", {:mineral => min}] } }

	def self.grade(commodity, year, options={})
	  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	  year_end = '31-DEC-'+year.to_s
	  year_start = '01-JAN-'+year.to_s
	  recorddate = "select MAX(recorddate) from mgd.resources mr
				where mr.eno = r.eno" # and mr.resourceno=mrg.resourceno and mrg.commodid = :commodity"
	  recorddate += " and recorddate <= :date"
	  sql = "select e1.eno, e1.entityid as deposit_name, e.entityid as zone_name, r.pvr as resource_pvr,
				r.pbr as resource_pbr, r.ppr as resource_ppr, r.mrs as resource_mrs, r.idr as resource_idr,
				r.mid as resource_mid, r.ifr as resource_ifr, r.other as resource_other, r.unit_quantity,
				r.inclusive, r.recorddate, r.material,
				rg.commodid as commodity, rg.unit_grade, rg.pvr, rg.pbr, rg.ppr, rg.mrs, rg.idr, rg.mid, rg.ifr, rg.other,
				rg.pvr_class1, rg.pbr_class1, rg.ppr_class1, rg.mrs_class1, rg.idr_class1, rg.mid_class1, rg.ifr_class1, rg.other_class1,
				rg.pvr_class2, rg.pbr_class2, rg.ppr_class2, rg.mrs_class2, rg.idr_class2, rg.mid_class2, rg.ifr_class2, rg.other_class2,
				rg.pvr_pcnt1, rg.pbr_pcnt1, rg.ppr_pcnt1, rg.mrs_pcnt1, rg.idr_pcnt1, rg.mid_pcnt1, rg.ifr_pcnt1, rg.other_pcnt1,
				rg.pvr_pcnt2, rg.pbr_pcnt2, rg.ppr_pcnt2, rg.mrs_pcnt2, rg.idr_pcnt2, rg.mid_pcnt2, rg.ifr_pcnt2, rg.other_pcnt2, ct.conversionfactor
				from mgd.resources r, mgd.resource_grades rg, a.entities e, a.entities e1, mgd.deposits d, mgd.commodtypes ct
				where r.resourceno = rg.resourceno and rg.commodid in (:commodity) and e.eno=r.eno and e.parent = e1.eno
				and ct.commodid = rg.commodid
				and e1.eno=d.eno
				and r.recorddate in (#{recorddate})"
	  sql += " and d.state = '#{options[:state]}'" if options[:state]
	  sql += " and e1.eno= '#{options[:eno]}'" if options[:eno]
	  Resource.find_by_sql([sql, {:commodity=>commodity,:date=>year_end}])
	end

  def self.aliased_commodities
	return {'coal'=>['Cbl','Cbr','Coal'],'fluorine'=>['F','Fl','Toz'],'lithium'=>['Li','Li2O'],'magnesite'=>['Mgs','MgO'],'molybdenum'=>['Mo','MoS2'],
		'niobium'=>['Nb','Nb2O5'],'lead_zinc'=>['Pb','Zn'],'platinum_group_elements'=>['Pt','PGE','Pd','Os','Ir','Rh','Ru'],
		'rare_earths'=>['REO','Y2O3','REE'],'tantalum'=>['Ta','Ta2O5'],'tin'=>['Sn','SnO2'],'tungsten'=>['W','WO3'],'uranium'=>['U','U3O8'],
		'vanadium'=>['V','V2O5']}
  end


  def identify
    ir = IdentifiedResource.new
    unless self.resource_grades.exists?

    end
    ir
  end


  #fix this -- remove coal

  def self.coal
	return  ['Cbl','Cbr','Coal']
  end

  def self.edr_classes
	return  ['IDE','DME','MDE']
  end

  def self.prm_classes
	return  ['IDP','DMP','MDP']
  end

  def self.sbm_classes
	return  ['IDS','DMS','MDS']
  end

  def self.ifr_classes
	return  ['IFE','IFS','IFU']
  end

  def self.ore_factors
	return  {nil=>0,'Kt'=>1000,'m3'=>1,'Kton'=>1016,'t'=>1,'bcm'=>1,'Mt'=>1000000,'Kg'=>0.001,'Mm3'=>1000000,
		'ton'=>1.016,'c'=>1,'Mc'=>1000000,'GL'=>1000000000,'Gt'=>1000000000}
  end

  def self.grade_factors
	return {nil=>0,'g/t'=>0.000001,'g/bcm'=>0.000001,'g/m3'=>0.000001,'Kg/t'=>0.001,'ppm'=>0.000001,'%'=>0.01, 'Kg/m3'=>0.001,
		'Kg/bcm'=>0.001,'g/lcm'=>0.000001,'c/t'=>1,'LT0M'=>1}
  end

  def self.get_resources (resource, ga_class, options={})


	pvr = get_pvr(resource, ga_class)
	pbr = get_pbr(resource, ga_class)
	ppr = get_ppr(resource, ga_class)
	mrs = get_mrs(resource, ga_class)
	idr = get_idr(resource, ga_class)
	mid = get_mid(resource, ga_class)
	ifr = ifr(resource, ga_class)
	other = other(resource, ga_class)


	if options["coal"] == "recoverable"
	  contained_metal = pvr[0]+pbr[0]+ppr[0]
	  ore = pvr[1]+pbr[1]+ppr[1]
	elsif options["coal"] == "insitu"
	  contained_metal = mrs[0]+idr[0]+mid[0].to_f+ifr[0].to_f+other[0].to_f
	  ore = mrs[1]+idr[1]+mid[1].to_f+ifr[1].to_f+other[1].to_f
	else
	  contained_metal = pvr[0]+pbr[0]+ppr[0]+mrs[0]+idr[0]+mid[0].to_f+ifr[0].to_f+other[0].to_f
	  ore = pvr[1]+pbr[1]+ppr[1]+mrs[1]+idr[1]+mid[1].to_f+ifr[1].to_f+other[1].to_f
	end
	return [contained_metal,ore]
  end

  def self.get_pvr (resource, ga_class)
	contained_metal = 0.0
	ore = 0.0
	resource_class = ga_class+"_classes"
	if send(resource_class).include?(resource.pvr_class1)
	  contained_metal += calculate_contained_commodity(resource,"pvr") * (resource.pvr_pcnt1.to_f/100)
	  ore += resource.resource_pvr.to_f * ore_factors[resource.unit_quantity].to_f
	end
	if send(resource_class).include?(resource.pvr_class2)
	  contained_metal += calculate_contained_commodity(resource,"pvr") * (resource.pvr_pcnt2.to_f/100)
	  ore += resource.resource_pvr.to_f * ore_factors[resource.unit_quantity].to_f
	end
	return [contained_metal,ore]
  end

  def self.get_pbr (resource, ga_class)
	contained_metal = 0.0
	ore = 0.0
	resource_class = ga_class+"_classes"
	if send(resource_class).include?(resource.pbr_class1)
	  contained_metal += calculate_contained_commodity(resource,"pbr") * (resource.pbr_pcnt1.to_f/100)
	  ore += resource.resource_pbr.to_f * ore_factors[resource.unit_quantity].to_f
	end
	if send(resource_class).include?(resource.pbr_class2)
	  contained_metal += calculate_contained_commodity(resource,"pbr") * (resource.pbr_pcnt2.to_f/100)
	  ore += resource.resource_pbr.to_f * ore_factors[resource.unit_quantity].to_f
	end
	return [contained_metal,ore]
  end

   def self.get_ppr (resource, ga_class)
	contained_metal = 0.0
	ore = 0.0
	resource_class = ga_class+"_classes"
	if send(resource_class).include?(resource.ppr_class1)
	  contained_metal += calculate_contained_commodity(resource,"ppr") * (resource.ppr_pcnt1.to_f/100)
	  ore += resource.resource_ppr.to_f * ore_factors[resource.unit_quantity].to_f
	end
	if send(resource_class).include?(resource.ppr_class2)
	  contained_metal += calculate_contained_commodity(resource,"ppr") * (resource.ppr_pcnt2.to_f/100)
	  ore += resource.resource_ppr.to_f * ore_factors[resource.unit_quantity].to_f
	end
	return [contained_metal,ore]
  end

  def self.get_mrs (resource, ga_class)
  	contained_metal = 0.0
	ore = 0.0
	resource_class = ga_class+"_classes"

	if send(resource_class).include?(resource.mrs_class1)
	  if resource.pvr && resource.resource_pvr && resource.inclusive == 'Y' && !coal.include?(resource.commodity)
		contained_metal += ( calculate_contained_commodity(resource,"mrs") - calculate_contained_commodity(resource,"pvr") )* resource.mrs_pcnt1.to_f/100
		ore += resource.resource_mrs.to_f * ore_factors[resource.unit_quantity].to_f - resource.resource_pvr.to_f * ore_factors[resource.unit_quantity].to_f
	  else
	    contained_metal +=  calculate_contained_commodity(resource,"mrs") * resource.mrs_pcnt1.to_f/100
		ore += resource.resource_mrs.to_f * ore_factors[resource.unit_quantity].to_f
	  end
	end

	if send(resource_class).include?(resource.mrs_class2)
	  if resource.pvr && resource.resource_pvr && resource.inclusive == 'Y' && !coal.include?(resource.commodity)
		contained_metal += ( calculate_contained_commodity(resource,"mrs") - calculate_contained_commodity(resource,"pvr") )* resource.mrs_pcnt2.to_f/100
		ore += resource.resource_mrs.to_f * ore_factors[resource.unit_quantity].to_f - resource.resource_pvr.to_f * ore_factors[resource.unit_quantity].to_f
	  else
	    contained_metal +=  calculate_contained_commodity(resource,"mrs") * resource.mrs_pcnt2.to_f/100
		ore += resource.resource_mrs.to_f * ore_factors[resource.unit_quantity].to_f
	  end
	end
	return [contained_metal,ore]
  end

  def self.get_idr (resource, ga_class)
  	contained_metal = 0.0
	ore = 0.0
	resource_class = ga_class+"_classes"

	if send(resource_class).include?(resource.idr_class1)
	  if resource.pbr && resource.resource_pbr && resource.inclusive == 'Y' && !coal.include?(resource.commodity)
		contained_metal += ( calculate_contained_commodity(resource,"idr") - calculate_contained_commodity(resource,"pbr") )* resource.idr_pcnt1.to_f/100
		ore += resource.resource_idr.to_f * ore_factors[resource.unit_quantity].to_f - resource.resource_pbr.to_f * ore_factors[resource.unit_quantity].to_f
	  else
	    contained_metal +=  calculate_contained_commodity(resource,"idr") * resource.idr_pcnt1.to_f/100
		ore += resource.resource_idr.to_f * ore_factors[resource.unit_quantity].to_f
	  end
	end

	if send(resource_class).include?(resource.idr_class2)
	  if resource.pbr && resource.resource_pbr && resource.inclusive == 'Y' && !coal.include?(resource.commodity)
		contained_metal += ( calculate_contained_commodity(resource,"idr") - calculate_contained_commodity(resource,"pbr") )* resource.idr_pcnt2.to_f/100
		ore += resource.resource_idr.to_f * ore_factors[resource.unit_quantity].to_f - resource.resource_pbr.to_f * ore_factors[resource.unit_quantity].to_f
	  else
	    contained_metal +=  calculate_contained_commodity(resource,"idr") * resource.idr_pcnt2.to_f/100
		ore += resource.resource_idr.to_f * ore_factors[resource.unit_quantity].to_f
	  end
	end
	return [contained_metal,ore]
  end

  def self.get_mid (resource, ga_class)
  	contained_metal = 0.0
	ore = 0.0
	resource_class = ga_class+"_classes"

	if send(resource_class).include?(resource.mid_class1)
	  if resource.inclusive == 'Y' && !coal.include?(resource.commodity)
		if resource.ppr && resource.resource_ppr
		  if (resource.mrs && resource.resource_mrs) || (resource.idr && resource.resource_idr)
			contained_metal += (calculate_contained_commodity(resource,"mrs") + calculate_contained_commodity(resource,"idr") - calculate_contained_commodity(resource,"ppr")) * resource.mid_pcnt1.to_f/100
			ore += resource.resource_mrs.to_f * ore_factors[resource.unit_quantity].to_f + resource.resource_idr.to_f * ore_factors[resource.unit_quantity].to_f - resource.resource_ppr.to_f * ore_factors[resource.unit_quantity].to_f
		  else
			contained_metal += (calculate_contained_commodity(resource,"mid") - calculate_contained_commodity(resource,"ppr")) * resource.mid_pcnt1.to_f/100
			ore += resource.resource_mid.to_f * ore_factors[resource.unit_quantity].to_f - resource.resource_ppr.to_f * ore_factors[resource.unit_quantity].to_f
		  end
		elsif (resource.pvr && resource.resource_pvr) || (resource.pbr && resource.resource_pbr)
			contained_metal += (calculate_contained_commodity(resource,"mid") - calculate_contained_commodity(resource,"pvr") - calculate_contained_commodity(resource,"pbr")) * resource.mid_pcnt1.to_f/100
			ore += resource.resource_mid.to_f * ore_factors[resource.unit_quantity].to_f - resource.resource_pvr.to_f * ore_factors[resource.unit_quantity].to_f + resource.resource_pbr.to_f * ore_factors[resource.unit_quantity].to_f
		end
	  else
		contained_metal += calculate_contained_commodity(resource,"mid") * resource.mid_pcnt1.to_f/100
		ore += resource.resource_mid.to_f * ore_factors[resource.unit_quantity].to_f
	  end
	end

	if send(resource_class).include?(resource.mid_class2)
	  if resource.inclusive == 'Y' && !coal.include?(resource.commodity)
		if resource.ppr && resource.resource_ppr
		  if (resource.mrs && resource.resource_mrs) || (resource.idr && resource.resource_idr)
			contained_metal += (calculate_contained_commodity(resource,"mrs") + calculate_contained_commodity(resource,"idr") - calculate_contained_commodity(resource,"ppr")) * resource.mid_pcnt2.to_f/100
			ore += resource.resource_mrs.to_f * ore_factors[resource.unit_quantity].to_f + resource.resource_idr.to_f * ore_factors[resource.unit_quantity].to_f - resource.resource_ppr.to_f * ore_factors[resource.unit_quantity].to_f
		  else
			contained_metal += (calculate_contained_commodity(resource,"mid") - calculate_contained_commodity(resource,"ppr")) * resource.mid_pcnt2.to_f/100
			ore += resource.resource_mid.to_f * ore_factors[resource.unit_quantity].to_f - resource.resource_ppr.to_f * ore_factors[resource.unit_quantity].to_f
		  end
		elsif (resource.pvr && resource.resource_pvr) || (resource.pbr && resource.resource_pbr)
			contained_metal += (calculate_contained_commodity(resource,"mid") - calculate_contained_commodity(resource,"pvr") - calculate_contained_commodity(resource,"pbr")) * resource.mid_pcnt2.to_f/100
			ore += resource.resource_mid.to_f * ore_factors[resource.unit_quantity].to_f - resource.resource_pvr.to_f * ore_factors[resource.unit_quantity].to_f + resource.resource_pbr.to_f * ore_factors[resource.unit_quantity].to_f
		end
	  else
		contained_metal += calculate_contained_commodity(resource,"mid") * resource.mid_pcnt2.to_f/100
		ore += resource.resource_mid.to_f * ore_factors[resource.unit_quantity].to_f
	  end
	end

	return [contained_metal,ore]
  end

  def self.ifr (resource, ga_class)
    contained_metal = 0.0
	ore = 0.0
	resource_class = ga_class+"_classes"
  	  if resource.ifr && resource.resource_ifr
		if send(resource_class).include?(resource.ifr_class1)
		  contained_metal += (resource.resource_ifr * ore_factors[resource.unit_quantity] )* (resource.ifr * grade_factors[resource.unit_grade] * resource.conversionfactor) * (resource.ifr_pcnt1.to_f/100)
		  ore += resource.resource_ifr * ore_factors[resource.unit_quantity]
		end
		if send(resource_class).include?(resource.ifr_class2)
		  contained_metal += (resource.resource_ifr * ore_factors[resource.unit_quantity])* (resource.ifr * grade_factors[resource.unit_grade] * resource.conversionfactor) * (resource.ifr_pcnt2.to_f/100)
		  ore += resource.resource_ifr * ore_factors[resource.unit_quantity]
		end
	  end
	return [contained_metal,ore]
  end

  def self.other (resource, ga_class)
	contained_metal = 0.0
	ore = 0.0
	resource_class = ga_class+"_classes"
	if resource.other && resource.resource_other
	  if send(resource_class).include?(resource.other_class1)
		contained_metal += (resource.resource_other * ore_factors[resource.unit_quantity])* (resource.other * grade_factors[resource.unit_grade] * resource.conversionfactor) * resource.other_pcnt1.to_f/100
		ore += resource.resource_other * ore_factors[resource.unit_quantity]
	  end
	  if send(resource_class).include?(resource.other_class2)
		contained_metal += (resource.resource_other * ore_factors[resource.unit_quantity])* (resource.other * grade_factors[resource.unit_grade] * resource.conversionfactor) * resource.other_pcnt2.to_f/100
		ore += resource.resource_other * ore_factors[resource.unit_quantity]
	  end
	end
	return [contained_metal,ore]
  end

  def self.calculate_contained_commodity (resource, jorc)
	jorc_ore = "resource_"+jorc
	return ( resource.send(jorc_ore).to_f * ore_factors[resource.unit_quantity].to_f ) * ( resource.send(jorc).to_f*grade_factors[resource.unit_grade].to_f ) * resource.conversionfactor
  end
	
end
