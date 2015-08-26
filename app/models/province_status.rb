class ProvinceStatus < ActiveRecord::Base
  self.table_name "provs.provinces"
  self.primary_key :provno

  belongs_to :province, :class_name => "Province"
end
