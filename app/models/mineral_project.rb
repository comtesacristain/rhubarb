class MineralProject < Entity 
    # attr_accessible :title, :body
  def self.sti_name
    "MINERAL PROJECT"
  end
  
  has_one :mineral_project_status, :class_name => "DepositStatus", :foreign_key => :eno
  
  #Change name to public? and put in Entity
  def atlas_visible?
    return quality_checked? && open_access? && geom?
  end
end

