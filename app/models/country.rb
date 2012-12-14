class Country < Entity
  def self.default_scope
    where(:entity_type => 'COUNTRY').merge(super)
  end
end
