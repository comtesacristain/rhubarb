class IdentifiedResource
	#attr_reader :reserves, :economic, :paramarginal, :submarginal, :inferred

  @@unit_codes= Hash[UnitCode.all.map {|u| [u.unitcode,u.unitvalue.to_f]}]
  @@commodity_types= Hash[CommodityType.all.map {|ct| [ct.commodid,Hash[:identified_commodity=>ct.convertedcommod,
        :conversion_factor=>ct.conversionfactor.to_f,:units=>{:ore=>ct.oreunit,:mineral=>ct.displayunit,:grade=>ct.gradeunit}]]}]

  def initialize(resource,grade)
    @reserves = Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    @economic = Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    @paramarginal = @economic.dup
    @submarginal = @economic.dup
    @inferred_resource = @economic.dup
    @inclusive = resource.inclusive
    #TODO: Change this to entrydate
    @update = resource.entrydate
    @date = resource.recorddate
    @material = resource.material
    set_jorc(resource,grade)
    commod = grade.commodid
    set_commodity(commod)
    set_units
  end

  def reserves
    r=Hash.new
    r[:ore] = reserves_raw[:ore] / @@unit_codes[@units[:ore]]
    r[:mineral] = reserves_raw[:mineral] / @@unit_codes[@units[:mineral]]
    r[:grade] = reserves_raw[:grade] / @@unit_codes[@units[:grade]]
    r[:units] = @units
    return r
  end

  def reserves_formatted
    return @reserves
  end

  def reserves_raw
    @reserves[:grade] = @reserves[:mineral]/@reserves[:ore] unless @reserves[:ore].zero?
    return @reserves
  end

  def economic
    e=Hash.new
    e[:ore] = economic_raw[:ore] / @@unit_codes[@units[:ore]]
    e[:mineral] = economic_raw[:mineral] / @@unit_codes[@units[:mineral]]
    e[:grade] = economic_raw[:grade] / @@unit_codes[@units[:grade]]
    e[:units] = @units
    return e
  end

  def economic_raw
    @economic[:grade] = @economic[:mineral]/@economic[:ore] unless @economic[:ore].zero?
    return @economic
  end

  def paramarginal
    p=Hash.new
    p[:ore] = paramarginal_raw[:ore] / @@unit_codes[@units[:ore]]
    p[:mineral] = paramarginal_raw[:mineral] / @@unit_codes[@units[:mineral]]
    p[:grade] = paramarginal_raw[:grade] / @@unit_codes[@units[:grade]]
    p[:units] = @units
    return p
  end

  def paramarginal_raw
    @paramarginal[:grade] = @paramarginal[:mineral]/@paramarginal[:ore] unless @paramarginal[:ore].zero?
    return @paramarginal
  end

  def submarginal
    s=Hash.new
    s[:ore] = submarginal_raw[:ore] / @@unit_codes[@units[:ore]]
    s[:mineral] = submarginal_raw[:mineral] / @@unit_codes[@units[:mineral]]
    s[:grade] = submarginal_raw[:grade] / @@unit_codes[@units[:grade]]
    s[:units] = @units
    return s
  end

  def submarginal_raw
    @submarginal[:grade] = @submarginal[:mineral]/@submarginal[:ore] unless @submarginal[:ore].zero?
    return @submarginal

  end

  def inferred
    i=Hash.new
    i[:ore] = inferred_raw[:ore] / @@unit_codes[@units[:ore]]
    i[:mineral] = inferred_raw[:mineral] / @@unit_codes[@units[:mineral]]
    i[:grade] = inferred_raw[:grade] / @@unit_codes[@units[:grade]]
    i[:units] = @units
    return i
  end

  def inferred_raw
    @inferred_resource[:grade] = @inferred_resource[:mineral]/@inferred_resource[:ore] unless @inferred_resource[:ore].zero?
    return @inferred_resource
  end
  
  def commodity
    return @commodity
  end
  
  def reported_commodity
    return @commodity[:reported_commodity]
  end
  
  def identified_commodity
    return @commodity[:identified_commodity]
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
  
  def measured
    return @measured
  end
  
  def indicated
    return @indicated
  end
 
  def measured_indicated
    return @measured_indicated
  end
  
  def inferred_resource
    return @inferred_resource
  end
 
  def other
    return @other
  end
  
  def units
    return @units
  end

  def date
    return @date
  end

  def material
    return @material
  end
  
  def update
    return @update
  end
  private

  # Pass resource and grade records into JORC code structured objects
  def set_jorc(resource,grade)
    jorc_reserves.each do |code, accessor|
      set_reserves(resource,grade,code,accessor)
    end
    jorc_resources.each do |code, accessor|
      set_resources(resource,grade,code,accessor)
    end
  end

  # Set reserves with calculation
  def set_reserves(r, g, code, acc)
    puts @commodity
    ore = r.send(code).to_f  * @@unit_codes[r.unit_quantity]
    grade = g.send(code).to_f * @@unit_codes[g.unit_grade]
    mineral = calculate_contained_mineral(r, g, code)
    resource = {:ore=>ore,:grade=>grade,:mineral=>mineral}

    classes=Hash["#{code}_class1"=>"#{code}_pcnt1","#{code}_class2"=>"#{code}_pcnt2"]
    identify_resources(g, resource, classes)

    self.instance_variable_set("@#{acc}", resource)
    
    # Only count current resources
    if r.current?
      @reserves[:ore]+=ore
      @reserves[:mineral]+=mineral
    end
  end


  def set_resources(r, g, code, acc)
    ore = r.send(code).to_f * @@unit_codes[r.unit_quantity]
    grade = g.send(code).to_f * @@unit_codes[g.unit_grade]
    mineral = calculate_contained_mineral(r, g, code)
    resource = {:ore=>ore,:grade=>grade,:mineral=>mineral}
    self.instance_variable_set("@#{acc}", resource)
    classes=Hash["#{code}_class1"=>"#{code}_pcnt1","#{code}_class2"=>"#{code}_pcnt2"]
    if @inclusive =='Y' && !code.in?([:ifr,:other])
      set_remnant(g, code, acc, classes)
    elsif
      identify_resources(g, resource, classes)
    end
    
  end

  def set_remnant(g, code, acc, class_hash)
    resource = Hash[:ore=>0.0,:grade=>0.0,:mineral=>0.0]
    case code
    when :mrs

      if !self.instance_variable_get("@proven_probable").values.delete_if{|x| x==0}.empty?
        self.instance_variable_set("@remnant_#{acc}",resource)
      else
        resource[:ore] = @measured[:ore] - @proven[:ore]
        resource[:mineral] = @measured[:mineral] - @proven[:mineral]
        resource[:grade] = (resource[:mineral]/resource[:ore]) rescue 0.0
        self.instance_variable_set("@remnant_#{acc}",resource)
      end
    when :idr
      if !self.instance_variable_get("@proven_probable").values.delete_if{|x| x==0}.empty?
        self.instance_variable_set("@remnant_#{acc}",resource)
      else
        resource[:ore] = @indicated[:ore] - @probable[:ore]
        resource[:mineral] = @indicated[:mineral] - @probable[:mineral]
        resource[:grade] = (resource[:mineral]/resource[:ore]) rescue 0.0
        self.instance_variable_set("@remnant_#{acc}",resource)
      end
    when :mid
      if self.instance_variable_get("@proven_probable").values.delete_if{|x| x==0}.empty? && self.instance_variable_get("@measured_indicated").values.delete_if{|x| x==0}.empty?
        self.instance_variable_set("@remnant_#{acc}",resource)
      else
        resource[:ore] = (@measured[:ore] + @indicated[:ore] + @measured_indicated[:ore]) - (@proven[:ore] + @probable[:ore] + @proven_probable[:ore])
        resource[:mineral] = (@measured[:mineral] + @indicated[:mineral] + @measured_indicated[:mineral]) - (@proven[:mineral] + @probable[:mineral] + @proven_probable[:mineral])
        resource[:grade] = (resource[:mineral]/resource[:ore]) rescue 0.0
        self.instance_variable_set("@remnant_#{acc}",resource)
      end
    end
    identify_resources(g, resource, class_hash)
  end

  def identify_resources(grade, resource_hash, class_hash)
    class_hash.each do |k,v|
      percentage= grade.send(v).to_f
      case
      when grade.send(k).in?(['IDE','DME','MDE'])
        @economic[:ore] += resource_hash[:ore]*percentage/100
        @economic[:mineral] += resource_hash[:mineral]*percentage/100
        #@economic[:grade] = (@economic[:mineral]/@economic[:ore]) rescue 0.0
      when grade.send(k).in?(['IDP','DMP','MDP'])
        @paramarginal[:ore] += resource_hash[:ore]*percentage/100
        @paramarginal[:mineral] += resource_hash[:mineral]*percentage/100
        #@paramarginal[:grade] = (@paramarginal[:mineral]/@paramarginal[:ore]) rescue 0.0
      when grade.send(k).in?(['IDS','DMS','MDS'])
        @submarginal[:ore] += resource_hash[:ore]*percentage/100
        @submarginal[:mineral] += resource_hash[:mineral]*percentage/100
        #@submarginal[:grade] = (@submarginal[:mineral]/@submarginal[:ore]) rescue 0.0
      when grade.send(k).in?(['IFE','IFS','IFU'])
        @inferred_resource[:ore] += resource_hash[:ore]*percentage/100
        @inferred_resource[:mineral] += resource_hash[:mineral]*percentage/100
        #@inferred_resource[:grade] = (@inferred_resource[:mineral]/@inferred_resource[:ore]) rescue 0.0
      end
    end
  end

  #reserves.values.delete_if{|x| x==0}.empty?
  #r=Resource.mineral('Au').recent.nonzero.all;irs=IdentifiedResourceSet.new(r)

  def calculate_contained_mineral (resource, grade, code)
    #need converted commodity factor
    return (resource.send(code).to_f * @@unit_codes[resource.unit_quantity]) * ( grade.send(code).to_f*@@unit_codes[grade.unit_grade].to_f ) * @@commodity_types[grade.commodid][:conversion_factor]
  end
  
  
  # Hash for JORC reserves.
  def jorc_reserves
    return {:pvr=>:proven,:pbr=>:probable,:ppr=>:proven_probable}
  end

  # Hash for JORC resources. Non-JORC code other included for ease of use.
  def jorc_resources
    return {:mrs=>:measured,:idr=>:indicated,:mid=>:measured_indicated,:ifr=>:inferred,:other=>:other}
  end
 
  # Combined Hash for all JORC codes.
  def jorc_codes
    return jorc_reserves.merge(jorc_resources)
  end

  def set_commodity(commodity)
   @commodity = @@commodity_types[commodity].merge(:reported_commodity=>commodity)
  end

  def set_units
    @units =  @commodity[:units]
  end
  
end
