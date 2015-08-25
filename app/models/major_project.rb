class MajorProject < Entity


  def self.sti_name 
    "RESOURCE PROJECT"
  end
  

  scope :by_name, lambda { |name| { :conditions=> ["UPPER(a.entities.entityid) like UPPER(:name)",{:name=> "%#{name}%"}] } }

  scope :bbox, lambda { |bbox| { :conditions => bounds_conditions(bbox) } }

  scope :public, :conditions=> {:activity_code=>'A'}

  
end
