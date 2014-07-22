class Company < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
  self.table_name = "mgd.companies"
end
