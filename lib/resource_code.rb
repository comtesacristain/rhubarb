class ResourceCode
  attr_accessor :ore, :grade, :mineral, :commodity, :units
  
  def initialize(*args)
    resource = args[0]
    @commodity = args[1]
    @units = args[2]
    case resource
    when Hash
      set_resources(resource)
      #      case
      #      when resource.size < 2
      #        raise ArgumentError, "Not enough arguments to define resource"
      #      else
      #        resource.each do |k,v|
      #          self.instance_variable_set("@#{k}",v)
      #        end
      #      end
    when NilClass
      @ore = Unit.new(0)
      @grade = Unit.new(0)
      @mineral = Unit.new(0)
    end
  end

  def +(other)
    #commodity_check(other)
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
        return CalculatedResource.new(Hash[:ore=>(self.ore+other.ore),:mineral=>(self.mineral+other.mineral)],@commodity)
      end
    when Numeric
      return CalculatedResource.new(Hash[:ore=>(self.ore+other),:mineral=>(self.mineral+other)],@commodity)
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
        return CalculatedResource.new(Hash[:ore=>(self.ore-other.ore),:mineral=>(self.mineral-other.mineral)],@commodity)
      end
    when Numeric
      return CalculatedResource.new(Hash[:ore=>(self.ore-other),:mineral=>(self.mineral-other)],@commodity)
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

  

  def zero?
    return @ore.zero? && @mineral.zero? && @grade.zero?
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

  def set_resources(resource)
    resource.each do |k,v|
      case v
      when Hash
        units=check_units(v[:units])
        case 
        when v[:value].nil?
          value = Unit.new(0,units)
        else
          value=Unit.new(v[:value],units)
        end
      when Unit
        value=v
      end
      self.instance_variable_set("@#{k}",value)
    end
  end

  def check_units(units)
    if units == 'bcm'
      return 't'
    elsif units == 'm3'
      return 't'
    elsif units == 'g/bcm'
      return 'g/t'
    elsif units == 'g/m3'
      return 'g/t'
    else
      return units
    end
  end




  def commodity_check(other)
    case @commodity
    when other
      return
    when Hash
      case other
      when Hash
        if @commodity[:identified_commodity] == other[:identified_commodity]
          @commodity[:reported_commodity] = [@commodity[:reported_commodity],other[:reported_commodity]].flatten.uniq
        else
          raise ArgumentError, "Defined commodities must match"
        end
      when String
        unless @commodity[:identified_commodity] == other[:identified_commodity]
          raise ArgumentError, "Defined commodities must match"
        end
      when NilClass
        return
      end
    when String
      unless @commodity[:identified_commodity] == other[:identified_commodity]
        raise ArgumentError, "Defined commodities must match"
      end
    when NilClass
      @commodity = other
    else
      raise ArgumentError, "Commodity must be a Hash or String"
    end

    #    case
    #    when other.commodity.nil?
    #      return
    #    when reported_commodity.nil?
    #      @commodity = Hash[:reported_commodity=>other.reported_commodity]
    #    when @commodity != other.commodity
    #      puts @commodity, other.commodity
    #      raise ArgumentError, "Defined commodities must match"
    #    end
  end

end