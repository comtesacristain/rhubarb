class IdentifiedResource
  #d=Deposit.state('NT').includes(:resources=>:resource_grades).merge(Resource.recent.mineral('MnOre').nonzero)
  #r=d.first.resources
  #irs=IdentifiedResourceSet.new(r)
  #ir=irs.first

  attr_accessor :commodity, :inclusive, :units, :eno, :resourceno
  @@commodity_type=CommodityType.all

  def initialize (ore, grade)
    #ore=ore
    #grade=grade
#    @eno=@ore.eno
#    @resourceno = @ore.resourceno
    @commodity=set_commodity(grade.commodid)
    @units=set_units
    @inclusive=@ore.inclusive
    set_proven(ore.pvr,ore.unit_quantity,grade.pvr,grade.unit_gradegrade.pvr_class1,grade.pvr_pcnt1,grade.pvr_class2,grade.pvr_pnt2)
  end


  ##

  def reserves
    return @reserves
  end

  def proven
    return @proven
  end

  def probable
    return @probable
  end

  def proven_probable
    return @proven_probable
  end


  private



  def set_proven(ore,o_units,grade,g_units,class1,pcnt1,class2,pcnt2)
#    resource = Hash[:ore,Hash[:value,@ore.pvr.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.pvr.to_f,:units,@grade.unit_grade]]
#    identified_code = Hash[@grade.pvr_class1,@grade.pvr_pcnt1.to_f,@grade.pvr_class2,@grade.pvr_pcnt2.to_f]
    o=Unit.new(ore.to_f,o_units) rescue Unit.new(0,ore_units)
    g=Unit.new(grade.to_f,g_units) rescue Unit.new(0,grade_units)
    mineral=(o*g).to(mineral_units) rescue Unit.new(0,mineral_units)
    @proven = {:ore=>o,:grade=>g,:mineral=>mineral}
  end

  def set_probable
    resource = Hash[:ore,Hash[:value,@ore.pbr.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.pbr.to_f,:units,@grade.unit_grade]]
    identified_code = Hash[@grade.pbr_class1,@grade.pbr_pcnt1.to_f,@grade.pbr_class2,@grade.pbr_pcnt2.to_f]
    @probable = JorcResource.new(resource,@commodity,@units,identified_code)
  end

  def set_proven_probable
    resource = Hash[:ore,Hash[:value,@ore.ppr.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.ppr.to_f,:units,@grade.unit_grade]]
    identified_code = Hash[@grade.ppr_class1,@grade.ppr_pcnt1.to_f,@grade.ppr_class2,@grade.ppr_pcnt2.to_f]
    @proven_probable = JorcResource.new(resource,@commodity,@units,identified_code)
  end

  def set_reserves
    set_proven
    set_probable
    set_proven_probable
    @reserves = @proven + @probable + @proven_probable
  end


  ## Calculates Economic Demonstrated Resources
  #  def economic
  #    if @inclusive == 'Y'
  #      return proven.economic + probable.economic + proven_probable.economic + remnant_measured.economic + remnant_indicated.economic + remnant_measured_indicated.economic + inferred.economic + other.economic
  #    else
  #      return proven.economic + probable.economic + proven_probable.economic + measured.economic + indicated.economic + measured_indicated.economic +  inferred.economic + other.economic
  #    end
  #  end
  #
  #  def paramarginal
  #    if @inclusive == 'Y'
  #      return proven.paramarginal + probable.paramarginal + proven_probable.paramarginal + remnant_measured.paramarginal + remnant_indicated.paramarginal + remnant_measured_indicated.paramarginal + inferred.paramarginal + other.paramarginal
  #    else
  #      return proven.paramarginal + probable.paramarginal + proven_probable.paramarginal + measured.paramarginal + indicated.paramarginal + measured_indicated.paramarginal +  inferred.paramarginal + other.paramarginal
  #    end
  #  end
  #
  #  def submarginal
  #    if @inclusive == 'Y'
  #      return proven.submarginal + probable.submarginal + proven_probable.submarginal + remnant_measured.submarginal + remnant_indicated.submarginal + remnant_measured_indicated.submarginal + inferred.submarginal + other.submarginal
  #    else
  #      return proven.submarginal + probable.submarginal + proven_probable.submarginal + measured.submarginal + indicated.submarginal + measured_indicated.submarginal +  inferred.submarginal + other.submarginal
  #    end
  #  end
  #
  #  def inferred_resource
  #    if @inclusive == 'Y'
  #      return proven.inferred + probable.inferred + proven_probable.inferred + remnant_measured.inferred + remnant_indicated.inferred + remnant_measured_indicated.inferred + inferred.inferred + other.inferred
  #    else
  #      return proven.inferred + probable.inferred + proven_probable.inferred + measured.inferred + indicated.inferred + measured_indicated.inferred +  inferred.inferred + other.inferred
  #    end
  #  end
  #
  #  def proven
  #    resource = Hash[:ore,Hash[:value,@ore.pvr.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.pvr.to_f,:units,@grade.unit_grade]]
  #    identified_code = Hash[@grade.pvr_class1,@grade.pvr_pcnt1.to_f,@grade.pvr_class2,@grade.pvr_pcnt2.to_f]
  #    return JorcResource.new(resource,@commodity,@units,identified_code)
  #  end
  #
  #  def probable
  #    resource = Hash[:ore,Hash[:value,@ore.pbr.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.pbr.to_f,:units,@grade.unit_grade]]
  #    identified_code = Hash[@grade.pbr_class1,@grade.pbr_pcnt1.to_f,@grade.pbr_class2,@grade.pbr_pcnt2.to_f]
  #    return JorcResource.new(resource,@commodity,@units,identified_code)
  #  end
  #
  #  def proven_probable
  #    resource = Hash[:ore,Hash[:value,@ore.ppr.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.ppr.to_f,:units,@grade.unit_grade]]
  #    identified_code = Hash[@grade.ppr_class1,@grade.ppr_pcnt1.to_f,@grade.ppr_class2,@grade.ppr_pcnt2.to_f]
  #    return JorcResource.new(resource,@commodity,@units,identified_code)
  #  end
  #
  #  def measured
  #    resource = Hash[:ore,Hash[:value,@ore.mrs.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.mrs.to_f,:units,@grade.unit_grade]]
  #    identified_code = Hash[@grade.mrs_class1,@grade.mrs_pcnt1.to_f,@grade.mrs_class2,@grade.mrs_pcnt2.to_f]
  #    return JorcResource.new(resource,@commodity,@units,identified_code)
  #  end
  #
  #  def remnant_measured
  #    unless measured.zero? || !proven_probable.zero?
  #      rm = measured-proven
  #    else
  #      rm = ResourceCode.new
  #    end
  #     resource = Hash[:ore,rm.ore,:mineral,rm.mineral]
  #    identified_code = Hash[@grade.mrs_class1,@grade.mrs_pcnt1.to_f,@grade.mrs_class2,@grade.mrs_pcnt2.to_f]
  #    return RemnantResource.new(resource,@commodity,@units,identified_code)
  #
  #  end
  #
  #  def indicated
  #    resource = Hash[:ore,Hash[:value,@ore.idr.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.idr.to_f,:units,@grade.unit_grade]]
  #    identified_code = Hash[@grade.idr_class1,@grade.idr_pcnt1.to_f,@grade.idr_class2,@grade.idr_pcnt2.to_f]
  #    return JorcResource.new(resource,@commodity,@units,identified_code)
  #  end
  #
  #  def remnant_indicated
  #    unless indicated.zero? || !proven_probable.zero?
  #      ri = indicated-probable
  #    else
  #      ri = ResourceCode.new
  #    end
  #    resource = Hash[:ore,ri.ore,:mineral,ri.mineral]
  #    identified_code = Hash[@grade.idr_class1,@grade.idr_pcnt1.to_f,@grade.idr_class2,@grade.idr_pcnt2.to_f]
  #    return RemnantResource.new(resource,@commodity,@units,identified_code)
  #
  #  end
  #
  #  def measured_indicated
  #    resource = Hash[:ore,Hash[:value,@ore.mid.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.mid.to_f,:units,@grade.unit_grade]]
  #    identified_code = Hash[@grade.mid_class1,@grade.mid_pcnt1.to_f,@grade.mid_class2,@grade.mid_pcnt2.to_f]
  #    return JorcResource.new(resource,@commodity,@units,identified_code)
  #  end
  #
  #  def remnant_measured_indicated
  #    if !proven_probable.zero? && !measured_indicated.zero?
  #      rmi=measured_indicated-proven_probable
  #    elsif !proven_probable.zero?
  #      rmi=measured+indicated-proven_probable
  #    elsif !measured_indicated.zero?
  #      rmi=measured_indicated-(proven+probable)
  #    else
  #      rmi=ResourceCode.new
  #    end
  #    resource = Hash[:ore,rmi.ore,:mineral,rmi.mineral]
  #    identified_code = Hash[@grade.mid_class1,@grade.mid_pcnt1.to_f,@grade.mid_class2,@grade.mid_pcnt2.to_f]
  #    return RemnantResource.new(resource,@commodity,@units,identified_code)
  #  end
  #
  #  def inferred
  #    resource = Hash[:ore,Hash[:value,@ore.ifr.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.ifr.to_f,:units,@grade.unit_grade]]
  #    identified_code = Hash[@grade.ifr_class1,@grade.ifr_pcnt1.to_f,@grade.ifr_class2,@grade.ifr_pcnt2.to_f]
  #    return JorcResource.new(resource,@commodity,@units,identified_code)
  #  end
  #
  #  def other
  #    resource = Hash[:ore,Hash[:value,@ore.other.to_f,:units,@ore.unit_quantity],:grade,Hash[:value,@grade.other.to_f,:units,@grade.unit_grade]]
  #    identified_code = Hash[@grade.other_class1,@grade.other_pcnt1.to_f,@grade.other_class2,@grade.other_pcnt2.to_f]
  #    return JorcResource.new(resource,@commodity,@units,identified_code)
  #  end
  #
  def identified_commodity
    @commodity[:identified_commodity]
  end
  
  def reported_commodity
    @commodity[:reported_commodity]
  end
  
  def mineral_units
    @units[:mineral]
  end
  
  def grade_units
    @units[:grade]
  end
  
  def ore_units
    @units[:ore]
  end




  def set_commodity(commodity)
    @@commodity_type.each do |ct|
      if commodity == ct.commodid
        return Hash[:identified_commodity=>ct.convertedcommod,:reported_commodity=>commodity,:conversion_factor=>ct.conversionfactor.to_f]
      end
    end
  end

  def set_units
    @@commodity_type.each do |ct|
      if identified_commodity == ct.commodid
        return Hash[:mineral=>ct.displayunit,:grade=>ct.gradeunit,:ore=>ct.oreunit]
      end
    end
  end


  def jorc_code
    return [:pvr,:pbr,:ppr,:mrs,:idr,:mid,:ifr,:other]
  end
end