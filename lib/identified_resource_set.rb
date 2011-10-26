class IdentifiedResourceSet < Array
  attr_reader :date, :material, :units
  @@unit_codes= Hash[UnitCode.all.map {|u| [u.unitcode,u.unitvalue.to_f]}]
  
  def initialize (resource)
    if resource.class == Array
      resource.each do |r|
        identified = IdentifiedResource.new(r)
        set_date(r.recorddate)
        set_material(r.material)
        self << identified
        @units = identified.units
      end
    elsif resource.class == Resource
      set_date(resource.recorddate)
      set_material(resource.material)
      identified = IdentifiedResource.new(resource)
      self << identified
    else
      raise ArgumentError, "Must be a Resource"
    end
  end

  def total
    return @economic + @paramarginal +  @submarginal + @inferred
  end

  def reserves
    r=Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    self.each do |ir|
      if r[:units].nil? then r[:units]=ir.reserves[:units] end
      r[:ore] += ir.reserves[:ore]
      r[:mineral] += ir.reserves[:mineral]
      
    end
    r[:grade] = (r[:mineral]/r[:ore]) / @@unit_codes[r[:units][:grade]] unless r[:ore].zero?
    return r
  end

  def economic
    e=Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    self.each do |ir|
      if e[:units].nil? then e[:units]=ir.reserves[:units] end
      e[:ore] += ir.economic[:ore]
      e[:mineral] += ir.economic[:mineral]
    end
    e[:grade] = (e[:mineral]/e[:ore]) / @@unit_codes[e[:units][:grade]] unless e[:ore].zero?
    return e
  end

  def paramarginal
    p=Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    self.each do |ir|
      if p[:units].nil? then p[:units]=ir.reserves[:units] end
      p[:ore] += ir.paramarginal[:ore]
      p[:mineral] += ir.paramarginal[:mineral]
    end
    p[:grade] = (p[:mineral]/p[:ore]) / @@unit_codes[p[:units][:grade]] unless p[:ore].zero?
    return p
  end

  def submarginal
    s=Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    self.each do |ir|
      if s[:units].nil? then s[:units]=ir.reserves[:units] end
      s[:ore] += ir.submarginal[:ore]
      s[:mineral] += ir.submarginal[:mineral]
    end
    s[:grade] = (s[:mineral]/s[:ore]) / @@unit_codes[s[:units][:grade]] unless s[:ore].zero?
    return s
  end

  def inferred
    i=Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    self.each do |ir|
      if i[:units].nil? then i[:units]=ir.reserves[:units] end
      i[:ore] += ir.inferred[:ore]
      i[:mineral] += ir.inferred[:mineral]
    end
    i[:grade] = (i[:mineral]/i[:ore]) / @@unit_codes[i[:units][:grade]] unless i[:ore].zero?
    return i
  end


  private

  def set_date(date)
    if @date.nil?
      @date=Hash.new
      @date[:start] = date
      @date[:end] = date
    elsif @date[:start] > date
      @date[:start] = date
    elsif @date[:end] < date
      @date[:end] = date
    end
  end

  def set_material(material)
    m=Array[material]
    if @material.nil?
      @material=m
    else
      @material = @material | m
    end
    @material.compact!
  end
end