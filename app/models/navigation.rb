class Navigation < Entity
  
  def self.sti_name 
    "SURVEY"
  end
  
  belongs_to :survey, :class_name => "Survey", :foreign_key => :eno
end
