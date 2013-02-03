module ZonesHelper
  def build_jorc_csv(resource,grade)
    codes = ["pvr","pbr","ppr","mrs","idr","mid","ifr","other"]
    jorc = Array.new
    @unit_grade=grade.unit_grade
    jorc <<  resource.recorddate << resource.unit_quantity << @unit_grade << grade.commodid << resource.inclusive
    codes.each do |code|
      @resource = resource.send(code)
      @grade = grade.send(code)
      contained_mineral = calculate_contained_mineral
      jorc << @resource << @grade << contained_mineral
    end
    return jorc
  end

  def calculate_contained_mineral
    @@unit_codes= Hash[UnitCode.all.map {|u| [u.unitcode,u.unitvalue.to_f]}]
    return @resource * @grade * @@unit_codes[@unit_grade] rescue nil
  end
end
