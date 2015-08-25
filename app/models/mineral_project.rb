class MineralProject < Entity 
    # attr_accessible :title, :body
  self.sti_name = "MINERAL PROJECT"
  
  has_one :mineral_project_status, :class_name => "DepositStatus", :foreign_key => :eno
  
  #Change name to public? and put in Entity
  def atlas_visible?
    return quality_checked? && open_access? && geom?
  end
end

