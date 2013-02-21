class ResourceCode
  attr_accessor :ore, :grade, :mineral, :commodity, :units
  
  def initialize(*args)
    resource = args[0]
    @commodity = args[1]
    @units = args[2]

    @ore = Unit.new(0)
    @grade = Unit.new(0)
    @mineral = Unit.new(0)
    
    case resource
    when Hash
      case 
      when resource.size < 2
        raise ArgumentError, "Not enough arguments to define resource"
      else
        resource.each do |k,v|
          send("set_#{k}",v)
        end
        validate_resource
      end
    end
  end

  def +(other)
    commodity_check(other)
    case other
    when ResourceCode
      case
      when self.zero?
        return other
        #when @commodity == other.commodity || other.commodity.nil? || @commodity.nil?
        #return ResourceCode.new(Hash[:ore=>(self.ore+other.ore),:mineral=>(self.mineral+other.mineral)],@commodity)
      when other.zero?
        return self
      else
        return ResourceCode.new(Hash[:ore=>(self.ore+other.ore),:mineral=>(self.mineral+other.mineral)],@commodity)
      end
    when Numeric
      return ResourceCode.new(Hash[:ore=>(self.ore+other),:mineral=>(self.mineral+other)],@commodity)
    when nil
      return self
    else
      raise ArgumentError,  "Incompatible Object"
    end
  end

  def -(other)
    commodity_check(other)
    case other
    when ResourceCode
      case
      when self.zero?
        return other
        #when @commodity == other.commodity || other.commodity.nil? || @commodity.nil?
        #return ResourceCode.new(Hash[:ore=>(self.ore+other.ore),:mineral=>(self.mineral+other.mineral)],@commodity)
      when other.zero?
        return self
      else
        return ResourceCode.new(Hash[:ore=>(self.ore-other.ore),:mineral=>(self.mineral-other.mineral)],@commodity)
      end
    when Numeric
      return ResourceCode.new(Hash[:ore=>(self.ore-other),:mineral=>(self.mineral-other)],@commodity)
    when nil
      return self
    else
      raise ArgumentError,  "Incompatible Object"
    end
#    commodity_check(other)
#    case other
#    when ResourceCode
#      case
#      when @commodity == other.commodity || other.commodity.nil?
#        return ResourceCode.new(Hash[:ore=>(self.ore-other.ore),:mineral=>(self.mineral-other.mineral)],@commodity)
#      else
#        raise ArgumentError,  "Incompatible Commodity"
#      end
#    when Numeric
#      return ResourceCode.new(Hash[:ore=>(self.ore-other),:mineral=>(self.mineral-other)],@commodity)
#    when nil
#      return self
#    else
#      raise ArgumentError,  "Incompatible Object"
#    end
  end

  def ore
    if @ore.zero?
      @ore=@mineral/@grade rescue 0
    end
    return @ore
  end
  
  def mineral
    if @mineral.zero?
      @mineral=@ore*@grade
    end
    return @mineral
  end
  
  def grade
    if @grade.zero?
      @grade=@mineral/@ore rescue 0
    end
    return @grade
  end

  def zero?
    return @ore.zero? || @mineral.zero? || @grade.zero?
  end

  def identified_commodity
    case @commodity
    when Hash
      return @commodity[:identified_commodity]
    when String
      return @commodity
    else
      return nil
    end

  end

  def reported_commodity
    case @commodity
    when Hash
      return @commodity[:reported_commodity]
    when String
      return @commodity
    else
      return nil
    end
  end

  def conversion_factor
    case @commodity
    when Hash
      return @commodity[:conversion_factor]
    when String
      return 1
    else
      return nil
    end
  end

  # Convert resource to units. Given in Hash

  def to(units)
    unless self.zero?
      case units
      when Hash
        @mineral=@mineral.to(units[:mineral]) if Unit.new(units[:mineral]).kind == :mass
        @ore=@ore.to(units[:ore]) if Unit.new(units[:ore]).kind == :mass
        @grade=@grade.to(units[:grade]) if Unit.new(units[:grade]).kind == :unitless
      when String
        unit=Unit.new(units)
        case unit.kind
        when :mass
          @mineral=@mineral.to(units)
          @ore=@ore.to(units)
        when :unitless
          @grade=@grade.to(units)
        else
          raise ArgumentError, "Incorrect units given, cannot convert!"
        end
      end
      return self
    else
      return ResourceCode.new
    end
  end

  private

  def set_ore(ore)
    case ore
    when Hash
      case
      when ore[:value].nil?
        @ore=Unit.new(0,ore[:units])
      else
        @ore=Unit.new(ore[:value],ore[:units])
      end
    when Unit
      @ore=ore
    end
  end

  def set_mineral(mineral)
    case mineral
    when Hash
      case
      when mineral[:value].nil?
        @mineral=Unit.new(0,mineral[:units])
      else
        @mineral=Unit.new(mineral[:value],mineral[:units])
      end
    when Unit
      @mineral=mineral
    end
  end

  def set_grade(grade)
    case grade
    when Hash
      case
      when grade[:value].nil?
        @grade=Unit.new(0,grade[:units])
      else
        @grade=Unit.new(grade[:value],grade[:units])
      end
    when Unit
      @grade =grade
    end
  end

  def validate_resource
    mineral if @mineral.zero?
    ore if @ore.zero?
    grade if @grade.zero?
  end

  def commodity_check(other)
    case
    when other.commodity.nil?
      return
    when reported_commodity.nil?
      @commodity = Hash[:reported_commodity=>other.reported_commodity]
    when @commodity != other.commodity
      raise ArgumentError, "Defined commodities must match"
    end
  end

end