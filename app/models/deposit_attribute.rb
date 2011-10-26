class DepositAttribute < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.deposdata"
	set_primary_key :eno
	scope :regname, :conditions => "attribname = 'REGNAME'"
	scope :minage_gp, :conditions => "attribname = 'MINAGE_GP'"
	scope :minsys_gp, :conditions => "attribname = 'MINSYS_GP'"
	scope :minsys_sgp, :conditions => "attribname = 'MINSYS_SGP'"
	scope :minsys_typ, :conditions => "attribname = 'MINSYS_TYP'"
	scope :classification, :conditions => "attribname = 'CLASSIFICATION'"
	scope :deposit_type, :conditions => "attribname = 'DEPOSIT TYPE'"

  set_date_columns :entrydate, :qadate, :lastupdate
end