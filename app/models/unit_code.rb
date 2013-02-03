class UnitCode < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.unit_codes"
	set_primary_key :unitcode

  def conversionfactor
    self.conversionfactor_before_type_cast
  end


  def self.factors
    return  {nil=>0,'Kt'=>1000,'m3'=>1,'Kton'=>1016,'t'=>1,'bcm'=>1,'Mt'=>1000000,
      'Kg'=>0.001,'Mm3'=>1000000, 'ton'=>1.016,'c'=>1,'Mc'=>1000000,'GL'=>1000000000,'Gt'=>1000000000,
      'g/t'=>0.000001,'g/bcm'=>0.000001,'g/m3'=>0.000001,'Kg/t'=>0.001,'ppm'=>0.000001,'%'=>0.01, 'Kg/m3'=>0.001,
      'Kg/bcm'=>0.001,'g/lcm'=>0.000001,'c/t'=>1,'LT0M'=>1}
  end

  def self.mass
    ['Gt','Kg','Kt','Kton','Mt','Mton','g','lb','oz','t','ton']
  end

  def self.carat
    ['Mc','c']
  end

  def self.volume
    ['Gl','l']
  end

  def self.energy
    ['PJ','J']
  end
end