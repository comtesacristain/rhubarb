class Navigation < Entity
  default_scope where(:entity_type => 'SURVEY')#, :order => "entityid"
end
