class ProvinceRelation < ActiveRecord::Base
  set_table_name "provs.provrels"
  set_primary_key :eno

  
  belongs_to :province, :class_name => "Province", :foreign_key => :eno
  belongs_to :relation, :class_name => "Province", :foreign_key => :releno
end
