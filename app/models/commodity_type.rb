class CommodityType < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	self.table_name = "mgd.commodtypes"
	self.primary_key = :commodid

	#belongs_to :commodity, :class_name => "Commodity", :foreign_key => :commodid
  has_many :commodities, :class_name => "Commodity", :foreign_key => :commodid
  has_many :deposits, :through => :commodities

  has_many :resource_grades, :class_name => "ResourceGrade", :foreign_key => :commodid
	has_many :resources, :through => :resource_grades

  def self.aliases
	  return {'base_metals'=>['Zn','Pb','Cu'],'black_coal'=>['Cbl'],'brown_coal'=>['Cbr'],'chromium'=>['Cr','Cr2O3'],'coal'=>['Cbl','Cbr','Coal'],
      'fluorine'=>['F','Fl','Toz'],'gypsum'=>['Gp'],'kaolin'=>'Kln','lithium'=>['Li','Li2O'],'manganese'=>['MnOre','Mn'],
      'magnesite'=>['Mgs','MgO'],'molybdenum'=>['Mo','MoS2'],'niobium'=>['Nb','Nb2O5'],'zinc_lead'=>['Pb','Zn'],'mineral_sands'=>['Ilm','Rt','Zrn'],
      'nickel_cobalt'=>['Ni','Co'],'ni_co_pge_sc'=>['Ni','Co','PGE','Pt','Pd','Os','Rh','Sc','Ir'],
      'ni_co_cu_pt_sc'=>['Ni','Co','Cu','Pt','Sc'],'platinum_group_elements'=>['Pt','PGE','Pd','Os','Ir','Rh','Ru'],
      'rare_earths'=>['REO','Y2O3','REE','Sc'],'tantalum'=>['Ta','Ta2O5'],'tin'=>['Sn','SnO2'],'tungsten'=>['W','WO3'],
      'uranium'=>['U','U3O8'],'vanadium'=>['V','V2O5']}
	end

	def self.aimr
		return { 'Antimony'=>'Sb', 'Bauxite'=>'Bx', 'Black coal'=>'Cbl', 'Brown coal'=>'Cbr', 'Chromium'=>'Cr', 'Cobalt'=>'Co',
      'Copper'=>'Cu', 'Diamond'=>'Dmd', 'Fluorine'=>'F', 'Gold'=>'Au','Iron Ore'=>'FeOre','Lead'=>'Pb','Lithium'=>'Li',
      'Magnesite'=>'Mgs', 'Manganese Ore'=>'MnOre','Mineral Sands'=>'mineral_sands','Molybdenum'=>'Mo','Nickel'=>'Ni',
      'Niobium'=>'Nb','Phosphate rock'=>'Phos','Platinum Group Elements'=>'platinum_group_elements','Rare Earths'=>'rare_earths',
      'Shale oil'=>'Osh','Silver'=>'Ag','Tantalum'=>'Ta','Thorium'=>'Th','Tin'=>'Sn','Tungsten'=>'W','Uranium'=>'U',
      'Vanadium'=>'V','Zinc'=>'Zn'}
	end

  def self.all_commodities
    a = Hash.new
    self.aliases.each_key do |k|
      a[k.titleize]=k
    end
    a["All"]=nil
    return self.aimr.merge(a)
  end
  
  # Queries
  
   def self.by_name(name)
     self.where("upper(commodname) like ?","%#{name.upcase}%")
   end
#   
  # # Lookups
#   
  # def self.names(name=nil)
    # unless name.nil?
      # return self.by_name(name).uniq.pluck(:commodname)
    # else
     # return self.uniq.pluck(:commodname)
    # end
  # end
  def self.find_as_keys(id=nil)
    unless id.nil?
      commodity_types=self.find(id)
    else
      commodity_types=self.all
    end
    return commodity_types.collect{|ct| {:id=>ct.commodid,:name=>ct.commodname}}
  end
end
