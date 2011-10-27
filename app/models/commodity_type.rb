class CommodityType < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.commodtypes"
	set_primary_key :commodid

	#belongs_to :commodity, :class_name => "Commodity", :foreign_key => :commodid
  has_many :commodities, :class_name => "Commodity", :foreign_key => :commodid
  has_many :deposits, :through => :commodities

  has_many :resource_grades, :class_name => "ResourceGrade", :foreign_key => :commodid
	has_many :resources, :through => :resource_grades

  def self.aliases
	  return {'base_metals'=>['Zn','Pb','Cu'],'black_coal'=>['Cbl'],'brown_coal'=>['Cbr'],'chromium'=>['Cr','Cr2O3'],'coal'=>['Cbl','Cbr','Coal'],
      'fluorine'=>['F','Fl','Toz'],'gypsum'=>['Gp'],'kaolin'=>'Kln','lithium'=>['Li','Li2O'],'manganese'=>['MnOre','Mn'],
      'magnesite'=>['Mgs','MgO'],'molybdenum'=>['Mo','MoS2'],'niobium'=>['Nb','Nb2O5'],'zinc_lead'=>['Pb','Zn'],'mineral_sands'=>['Ilm','Rt','Zrn'],
      'ni_co_cu_pt_sc'=>['Ni','Co','Cu','Pt','Sc'],'platinum_group_elements'=>['Pt','PGE','Pd','Os','Ir','Rh','Ru'],
      'rare_earths'=>['REO','Y2O3','REE','Sc'],'tantalum'=>['Ta','Ta2O5'],'tin'=>['Sn','SnO2'],'tungsten'=>['W','WO3'],
      'uranium'=>['U3O8','U'],'vanadium'=>['V','V2O5']}
	end

	def self.aimr
		return { 'Antimony'=>'Sb', 'Bauxite'=>'Bx', 'Black coal'=>'Cbl', 'Brown coal'=>'Cbr', 'Cadmium'=>'Cd', 'Chromium'=>'chromium', 'Cobalt'=>'Co',
      'Copper'=>'Cu', 'Diamond'=>'Dmd', 'Fluorine'=>'fluorine', 'Gold'=>'Au','Iron Ore'=>'FeOre','Lead'=>'Pb','Lithium'=>'lithium',
      'Magnesite'=>'magnesite', 'Manganese Ore'=>'MnOre','Mineral Sands'=>'mineral_sands','Molybdenum'=>'molybdenum','Nickel'=>'Ni',
      'Niobium'=>'niobium','Phosphate rock'=>'Phos','Platinum Group Elements'=>'platinum_group_elements','Rare Earths'=>'rare_earths',
      'Shale oil'=>'Osh','Silver'=>'Ag','Tantalum'=>'tantalum','Thorium'=>'Th','Tin'=>'tin','Tungsten'=>'tungsten','Uranium'=>'uranium',
      'Vanadium'=>'vanadium','Zinc'=>'Zn'}
	end

  def self.all_commodities
    a = Hash.new
    self.aliases.each_key do |k|
      a[k.titleize]=k
    end
    a["All"]="All"
    return self.aimr.merge(a)
  end
end
