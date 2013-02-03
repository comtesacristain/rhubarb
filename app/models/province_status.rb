class ProvinceStatus < ActiveRecord::Base
  set_table_name "provs.provinces"
  set_primary_key :provno

  belongs_to :province, :class_name => "Province"
end
