class ProvinceRelation < ActiveRecord::Base
  self.table_name "provs.provrels"
  self.primary_key :eno

  
  belongs_to :province, :class_name => "Province", :foreign_key => :eno
  belongs_to :relation, :class_name => "Province", :foreign_key => :releno
end
