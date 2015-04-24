class Navigation < Entity
  
  def self.default_scope
    self.where(:entity_type => 'SURVEY')
  end

  belongs_to :survey, :class_name => "Survey", :foreign_key => :eno
end
