class Measurement
  attr_accessor :quantity, :units, :dimension, :base_units
  @@unit_codes=UnitCode.all
  
  def initialize (quantity=0.0, units=nil)
    @quantity = quantity
    @units= units
    set_unit_code
    set_dimension
  end

  def value
    return Float quantity*unit_factor rescue 0.0
  end

  def unit_factor
    return Float @unit_code.unitvalue
  end

  def +(other)
    unless other.class== Measurement
      return 0
    end
    if @units==other.units
      return Measurement.new(@quantity+other.quantity,@units)
    elsif @dimension==other.dimension
      return Measurement.new(value+other.value,@base_units)
    end
  end

  private
  def set_unit_code
    @@unit_codes.each do |uc|
      String @unit_code = uc if uc.unitcode == @units
    end
  end

  def set_dimension
    if @units.in?(UnitCode.mass)
      @dimension='mass'
      @base_units= 't'
    elsif @units.in?(UnitCode.carat)
      @dimension='carat'
      @base_units= 'c'
    elsif @units.in?(UnitCode.volume)
      @dimension='volume'
      @base_units= 'l'
    elsif @units.in?(UnitCode.energy)
      @dimension='energy'
      @base_units= 'J'
    else
      @dimension='unknown'
    end
  end

end