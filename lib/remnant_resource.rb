class RemnantResource < CalculatedResource
  attr_accessor :identified_code,:economic,:paramarginal,:submarginal,:inferred
  def initialize(*args)
    super
    @identified_code=args[3]
    @economic = ResourceCode.new
    @paramarginal = ResourceCode.new
    @submarginal = ResourceCode.new
    @inferred = ResourceCode.new
    unless @identified_code.nil?
      identify
    end
  end
  
  private


  def identify
    @identified_code.each do |k,v|
      case
      when k.in?(['IDE','DME','MDE'])
        @economic = CalculatedResource.new(Hash[:ore=>(@ore*Unit.new(v,'%')),:mineral=>(@mineral*Unit.new(v,'%')*conversion_factor)],@commodity)
        @economic=@economic.to(@units)
      when k.in?(['IDP','DMP','MDP'])
        @paramarginal = CalculatedResource.new(Hash[:ore=>(@ore*Unit.new(v,'%')),:mineral=>(@mineral*Unit.new(v,'%')*conversion_factor)],@commodity)
        @paramarginal=@paramarginal.to(@units)
      when k.in?(['IDS','DMS','MDS'])
        @submarginal = CalculatedResource.new(Hash[:ore=>(@ore*Unit.new(v,'%')),:mineral=>(@mineral*Unit.new(v,'%')*conversion_factor)],@commodity)
        @submarginal=@submarginal.to(@units)
      when k.in?(['IFE','IFS','IFU'])
        @inferred = CalculatedResource.new(Hash[:ore=>(@ore*Unit.new(v,'%')),:mineral=>(@mineral*Unit.new(v,'%')*conversion_factor)],@commodity)
        @inferred=@inferred.to(@units)
      end
    end


  end
end