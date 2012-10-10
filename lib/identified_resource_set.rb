class IdentifiedResourceSet < Hash
  # 
  
  attr_reader :date, :material, :units
  @@unit_codes= Hash[UnitCode.all.map {|u| [u.unitcode,u.unitvalue.to_f]}]
  
  def initialize (resource)
    if resource.class == Array
      resource.each do |r|
        grades = r.resource_grades
        grades.each do |g|
          identified = IdentifiedResource.new(r,g)
          unless self.key?(identified.identified_commodity)
            self[identified.identified_commodity]=Array.new
          end
          self[identified.identified_commodity]<<identified
        end
        set_date(r.recorddate)
        set_material(r.material)
        
        #@units = identified.units
      end
    elsif resource.class == Resource
      set_date(resource.recorddate)
      set_material(resource.material)
      grades = resource.resource_grades
      grades.each do |g|
        identified = IdentifiedResource.new(resource,g)
        unless self.key?(identified.identified_commodity)
          self[identified.identified_commodity]=Array.new
        end
        self[identified.identified_commodity]<<identified          
      end
    else
      raise ArgumentError, "Must be a Resource"
    end
  end

  def total
    return @economic + @paramarginal +  @submarginal + @inferred
  end

  def reserves
    r=Hash.new
    self.keys.each do |k|
      r[k]=get_code(k,:reserves)
    end
    return r
  end
  
  def economic
    e=Hash.new
    self.keys.each do |k|
      e[k]=get_code(k,:economic)
    end
    return e
  end
  
  def paramarginal
    p=Hash.new
    self.keys.each do |k|
      p[k]=get_code(k,:paramarginal)
    end
    return p
  end
  
  def submarginal
    s=Hash.new
    self.keys.each do |k|
      s[k]=get_code(k,:submarginal)
    end
    return s
  end
  
  def inferred
    i=Hash.new
    self.keys.each do |k|
      i[k]=get_code(k,:inferred)
    end
    return i
  end
  
  def commodities
    return self.keys
  end

  private
  

  def get_code(key, code)
    c=Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    self[key].each do |ir|
      if c[:units].nil? then c[:units]=ir.send(code)[:units] end
      c[:ore] += ir.send(code)[:ore]
      c[:mineral] += ir.send(code)[:mineral]
    end
    c[:grade] = ((c[:mineral]*@@unit_codes[c[:units][:mineral]])/(c[:ore]*@@unit_codes[c[:units][:ore]])) / @@unit_codes[c[:units][:grade]] unless c[:ore].zero?
    return c
  end

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