class Navigation < Entity
  
  
  #XXX There _MUST_ be a better way of doing this
  def self.default_scope
    self.where(:entity_type => 'SURVEY').merge(super)
  end

end
