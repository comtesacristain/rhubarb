class IdentifiedResourceSet < Hash
  # 
  
  attr_reader :date, :material, :units, :inclusive,:update
  @@unit_codes= Hash[UnitCode.all.map {|u| [u.unitcode,u.unitvalue.to_f]}]
  
  def initialize (resource)
    if resource.class ==  Resource::ActiveRecord_Relation
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
        set_inclusive(r.inclusive)
        set_update(r.entrydate)
        
        #@units = identified.units
      end
    elsif resource.class == Resource
      set_date(resource.recorddate)
      set_material(resource.material)
      set_inclusive(resource.inclusive)
      set_update(resource.entrydate)
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
  
  
  def proven
    pvr=Hash.new
    self.keys.each do |k|
      pvr[k]=get_jorc_code(k,:proven)
    end
    return pvr
  end
  
  def probable
    pbr=Hash.new
    self.keys.each do |k|
      pbr[k]=get_jorc_code(k,:probable)
    end
    return pbr
  end
  
  def proven_probable
    ppr=Hash.new
    self.keys.each do |k|
      ppr[k]=get_jorc_code(k,:proven_probable)
    end
    return ppr
  end
  
  def measured
    mrs=Hash.new
    self.keys.each do |k|
      mrs[k]=get_jorc_code(k,:measured)
    end
    return mrs
  end
  
  def indicated
    idr=Hash.new
    self.keys.each do |k|
      idr[k]=get_jorc_code(k,:indicated)
    end
    return idr
  end
  
  def measured_indicated
    mid=Hash.new
    self.keys.each do |k|
      mid[k]=get_jorc_code(k,:measured_indicated)
    end
    return mid
  end
 
  def inferred_resource
    ifr=Hash.new
    self.keys.each do |k|
      ifr[k]=get_jorc_code(k,:inferred_resource)
    end
    return ifr
  end
  
  def other
    other=Hash.new
    self.keys.each do |k|
      other[k]=get_jorc_code(k,:other)
    end
    return other
  end
  
  def commodities
    return self.keys
  end

  private
  
  
  def get_jorc_code(key, code)
    c=Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    ore=0.0
    mineral=0.0
    self[key].each do |ir|
      if c[:units].nil? then c[:units]=ir.units end
      ore += ir.send(code)[:ore]
      mineral += ir.send(code)[:mineral]
      
    end
    c[:ore] += ore / @@unit_codes[c[:units][:ore]]
    c[:mineral] += mineral / @@unit_codes[c[:units][:mineral]]
    #m=c[:mineral]*@@unit_codes[c[:units][:mineral]]
    c[:grade] = mineral/ore / @@unit_codes[c[:units][:grade]] unless c[:ore].zero?
    return c
  end
  

  def get_code(key, code)
    c=Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    self[key].each do |ir|
      if c[:units].nil? then c[:units]=ir.units end
      c[:ore] += ir.send(code)[:ore]
      c[:mineral] += ir.send(code)[:mineral]
    end
    #m=c[:mineral]*@@unit_codes[c[:units][:mineral]]
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
  
  def set_update(update)
    #TODO define better
    
    if @update.nil?
      @update=update
    elsif update > @update
      @update=update
    end
  end

  
  def set_inclusive(inclusive)
    #TODO define better
    
    if @inclusive.nil?
      @inclusive=inclusive
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