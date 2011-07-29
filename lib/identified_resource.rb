class IdentifiedResource
	attr_accessor :commodity, :grade_unit, :grade_factor, :commodity_unit, :commodity_factor, :ore_unit, :ore_factor,
		:year, :recorddate, :material, :edr_ore, :edr_commodity, :dmp_ore, :dmp_commodity, :dms_ore, :dms_commodity, :ifr_ore, :ifr_commodity
	
  def initialize
    @edr_commodity = 0.0
    @edr_ore = 0.0
    @dmp_commodity = 0.0
    @dmp_ore = 0.0
    @dms_commodity = 0.0
    @dms_ore = 0.0
    @ifr_commodity = 0.0
    @ifr_ore = 0.0
  end
	
  def set_commodity (commod)
    if CommodityType.aliases.include?(commod)
      commod = CommodityType.aliases[commod]
      self.commodity = CommodityType.find(commod[0]).convertedcommod
    else
      self.commodity=commod
    end
    self.commodity_unit = CommodityType.find(self.commodity).displayunit
    self.grade_unit = CommodityType.find(self.commodity).gradeunit
    self.ore_unit = CommodityType.find(self.commodity).oreunit
	 
    self.commodity_factor = UnitCode.find(self.commodity_unit).unitvalue
    self.grade_factor = UnitCode.find(self.grade_unit).unitvalue if self.grade_unit
    self.ore_factor = UnitCode.find(self.ore_unit).unitvalue if  self.ore_unit
  end

  def total_ore
    return edr_ore + dmp_ore + dms_ore + ifr_ore
  end

  def total_commodity
    return edr_commodity + dmp_commodity + dms_commodity + ifr_commodity
  end

  def total_grade
    if total_ore != 0
      return total_commodity/total_ore
    else
      return 0
    end
  end
	
  def edr_grade
    if edr_ore != 0
      return edr_commodity/edr_ore
    else
      return 0
    end
  end
  
  def dmp_grade
    if dmp_ore != 0
      return dmp_commodity/dmp_ore
    else
      return 0
    end
  end
  
  def dms_grade
		if dms_ore != 0
      return dms_commodity/dms_ore
    else
      return 0
    end
  end
  
  def ifr_grade
		if ifr_ore != 0
      return ifr_commodity/ifr_ore
    else
      return 0
    end
  end


  def jorc
    ["pvr", "pbr", "ppr", "mrs", "idr", "mid", "ifr", "other"]
  end

  def identify_resources(resource, grade)

    jorc = self.jorc
    jorc.each do |j|
      puts "#{resource.send(j)}, #{grade.send(j)},"
    end

  end







  def set_resources (resource, options={})
    unless resource.is_a? Array
      resource=[resource]
    end
    date = Date.new
    resource.each do |r|
	  
      self.set_commodity(r.commodity)
      if options["coal"] == "recoverable"
        self.edr_ore += get_pvr(r, "edr")[:ore] + get_pbr(r, "edr")[:ore] + get_ppr(r, "edr")[:ore]
        self.edr_commodity += get_pvr(r, "edr")[:commodity] + get_pbr(r, "edr")[:commodity] + get_ppr(r, "edr")[:commodity]
        self.dmp_ore += get_pvr(r, "dmp")[:ore] + get_pbr(r, "dmp")[:ore] + get_ppr(r, "dmp")[:ore]
        self.dmp_commodity += get_pvr(r, "dmp")[:commodity] + get_pbr(r, "dmp")[:commodity] + get_ppr(r, "dmp")[:commodity]
        self.dms_ore += get_pvr(r, "dms")[:ore] + get_pbr(r, "dms")[:ore] + get_ppr(r, "dms")[:ore]
        self.dms_commodity += get_pvr(r, "dms")[:commodity] + get_pbr(r, "dms")[:commodity] + get_ppr(r, "dms")[:commodity]
        self.ifr_ore += get_pvr(r, "ifr")[:ore] + get_pbr(r, "ifr")[:ore] + get_ppr(r, "ifr")[:ore]
        self.ifr_commodity += get_pvr(r, "ifr")[:commodity] + get_pbr(r, "ifr")[:commodity] + get_ppr(r, "ifr")[:commodity]
      elsif options["coal"] == "insitu"
        self.edr_ore += get_mrs(r, "edr")[:ore] + get_idr(r, "edr")[:ore] + get_mid(r, "edr")[:ore] + ifr(r, "edr")[:ore] + other(r, "edr")[:ore]
        self.edr_commodity += get_mrs(r, "edr")[:commodity] + get_idr(r, "edr")[:commodity] + get_mid(r, "edr")[:commodity] + ifr(r, "edr")[:commodity] + other(r, "edr")[:commodity]
        self.dmp_ore += get_mrs(r, "dmp")[:ore] + get_idr(r, "dmp")[:ore] + get_mid(r, "dmp")[:ore] + ifr(r, "dmp")[:ore] + other(r, "dmp")[:ore]
        self.dmp_commodity += get_mrs(r, "dmp")[:commodity] + get_idr(r, "dmp")[:commodity] + get_mid(r, "dmp")[:commodity] + ifr(r, "dmp")[:commodity] + other(r, "dmp")[:commodity]
        self.dms_ore += get_mrs(r, "dms")[:ore] + get_idr(r, "dms")[:ore] + get_mid(r, "dms")[:ore] + ifr(r, "dms")[:ore] + other(r, "dms")[:ore]
        self.dms_commodity += get_mrs(r, "dms")[:commodity] + get_idr(r, "dms")[:commodity] + get_mid(r, "dms")[:commodity] + ifr(r, "dms")[:commodity] + other(r, "dms")[:commodity]
        self.ifr_ore += get_mrs(r, "ifr")[:ore] + get_idr(r, "ifr")[:ore] + get_mid(r, "ifr")[:ore] + ifr(r, "ifr")[:ore] + other(r, "ifr")[:ore]
        self.ifr_commodity += get_mrs(r, "ifr")[:commodity] + get_idr(r, "ifr")[:commodity] + get_mid(r, "ifr")[:commodity] + ifr(r, "ifr")[:commodity] + other(r, "ifr")[:commodity]
      else
        self.edr_ore += get_pvr(r, "edr")[:ore] + get_pbr(r, "edr")[:ore] + get_ppr(r, "edr")[:ore] + get_mrs(r, "edr")[:ore] + get_idr(r, "edr")[:ore] + get_mid(r, "edr")[:ore] + ifr(r, "edr")[:ore] + other(r, "edr")[:ore]
        self.edr_commodity += get_pvr(r, "edr")[:commodity] + get_pbr(r, "edr")[:commodity] + get_ppr(r, "edr")[:commodity] + get_mrs(r, "edr")[:commodity] + get_idr(r, "edr")[:commodity] + get_mid(r, "edr")[:commodity] + ifr(r, "edr")[:commodity] + other(r, "edr")[:commodity]
        self.dmp_ore += get_pvr(r, "dmp")[:ore] + get_pbr(r, "dmp")[:ore] + get_ppr(r, "dmp")[:ore] + get_mrs(r, "dmp")[:ore] + get_idr(r, "dmp")[:ore] + get_mid(r, "dmp")[:ore] + ifr(r, "dmp")[:ore] + other(r, "dmp")[:ore]
        self.dmp_commodity += get_pvr(r, "dmp")[:commodity] + get_pbr(r, "dmp")[:commodity] + get_ppr(r, "dmp")[:commodity] + get_mrs(r, "dmp")[:commodity] + get_idr(r, "dmp")[:commodity] + get_mid(r, "dmp")[:commodity] + ifr(r, "dmp")[:commodity] + other(r, "dmp")[:commodity]
        self.dms_ore += get_pvr(r, "dms")[:ore] + get_pbr(r, "dms")[:ore] + get_ppr(r, "dms")[:ore] + get_mrs(r, "dms")[:ore] + get_idr(r, "dms")[:ore] + get_mid(r, "dms")[:ore] + ifr(r, "dms")[:ore] + other(r, "dms")[:ore]
        self.dms_commodity += get_pvr(r, "dms")[:commodity] + get_pbr(r, "dms")[:commodity] + get_ppr(r, "dms")[:commodity] + get_mrs(r, "dms")[:commodity] + get_idr(r, "dms")[:commodity] + get_mid(r, "dms")[:commodity] + ifr(r, "dms")[:commodity] + other(r, "dms")[:commodity]
        self.ifr_ore += get_pvr(r, "ifr")[:ore] + get_pbr(r, "ifr")[:ore] + get_ppr(r, "ifr")[:ore] + get_mrs(r, "ifr")[:ore] + get_idr(r, "ifr")[:ore] + get_mid(r, "ifr")[:ore] + ifr(r, "ifr")[:ore] + other(r, "ifr")[:ore]
        self.ifr_commodity += get_pvr(r, "ifr")[:commodity] + get_pbr(r, "ifr")[:commodity] + get_ppr(r, "ifr")[:commodity] + get_mrs(r, "ifr")[:commodity] + get_idr(r, "ifr")[:commodity] + get_mid(r, "ifr")[:commodity] + ifr(r, "ifr")[:commodity] + other(r, "ifr")[:commodity]
      end
      if r.recorddate > date
        date = r.recorddate
        self.material = r.material
      end
    end
    self.recorddate = date
  end
  
  def get_pvr (resource, ga_class)
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
    return {:commodity => contained_metal,:ore=>ore}
  end
  
  def get_pbr (resource, ga_class)
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
    return {:commodity => contained_metal,:ore=>ore}
  end
  
  def get_ppr (resource, ga_class)
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
    return {:commodity => contained_metal,:ore=>ore}
  end
  
  def get_mrs (resource, ga_class)
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
    return {:commodity => contained_metal,:ore=>ore}
  end
  
  def get_idr (resource, ga_class)
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
    return {:commodity => contained_metal,:ore=>ore}
  end
  
  def get_mid (resource, ga_class)
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

    return {:commodity => contained_metal,:ore=>ore}
  end
  
  def ifr (resource, ga_class)
    contained_metal = 0.0
    ore = 0.0
    resource_class = ga_class+"_classes"
    if resource.ifr && resource.resource_ifr
      if send(resource_class).include?(resource.ifr_class1)
        contained_metal += (resource.resource_ifr.to_f * ore_factors[resource.unit_quantity].to_f )* (resource.ifr.to_f * grade_factors[resource.unit_grade].to_f * resource.conversionfactor.to_f) * (resource.ifr_pcnt1.to_f/100)
        ore += resource.resource_ifr.to_f * ore_factors[resource.unit_quantity].to_f
      end
      if send(resource_class).include?(resource.ifr_class2)
        contained_metal += (resource.resource_ifr.to_f * ore_factors[resource.unit_quantity])* (resource.ifr.to_f * grade_factors[resource.unit_grade] * resource.conversionfactor) * (resource.ifr_pcnt2.to_f/100)
        ore += resource.resource_ifr * ore_factors[resource.unit_quantity]
      end
    end
    return {:commodity => contained_metal,:ore=>ore}
  end
  
  def other (resource, ga_class)
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
    return {:commodity => contained_metal,:ore=>ore}
  end
  
  def calculate_contained_commodity (resource, jorc)
    jorc_ore = "resource_"+jorc
    return ( resource.send(jorc_ore).to_f * ore_factors[resource.unit_quantity].to_f ) * ( resource.send(jorc).to_f*grade_factors[resource.unit_grade].to_f ) * resource.conversionfactor
  end
  
  private
  
  def coal
    return  ['Cbl','Cbr','Coal']
  end
  
  def edr_classes
    return  ['IDE','DME','MDE']
  end
  
  def dmp_classes
    return  ['IDP','DMP','MDP']
  end
  
  def dms_classes
    return  ['IDS','DMS','MDS']
  end
  
  def ifr_classes
    return  ['IFE','IFS','IFU']
  end
  
  def ore_factors
    return  {nil=>0,'Kt'=>1000,'m3'=>1,'Kton'=>1016,'t'=>1,'bcm'=>1,'Mt'=>1000000,'Kg'=>0.001,'Mm3'=>1000000, 'ton'=>1.016,'c'=>1,'Mc'=>1000000,'GL'=>1000000000,'Gt'=>1000000000}
  end
  
  def grade_factors
    return {nil=>0,'g/t'=>0.000001,'g/bcm'=>0.000001,'g/m3'=>0.000001,'Kg/t'=>0.001,'ppm'=>0.000001,'%'=>0.01, 'Kg/m3'=>0.001,
      'Kg/bcm'=>0.001,'g/lcm'=>0.000001,'c/t'=>1,'LT0M'=>1}
  end
  
end