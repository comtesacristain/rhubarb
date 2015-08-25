class Navigation < Entity
  
  self.sti_name = "SURVEY"

  belongs_to :survey, :class_name => "Survey", :foreign_key => :eno
end
