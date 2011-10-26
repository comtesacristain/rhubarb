class CalculatedResource < ResourceCode

  def initialize(*args)
    super
    @grade=set_grade
  end

  def set_grade
    case
    when @ore.zero?
      return Unit.new(0,'%')
    else
      return @mineral/@ore
    end
    
  end


end