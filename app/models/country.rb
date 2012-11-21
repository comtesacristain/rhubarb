class Country < Entity
  default_scope where(:entity_type => 'COUNTRY')#, :order => "entityid"
end
