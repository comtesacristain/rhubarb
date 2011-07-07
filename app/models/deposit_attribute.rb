class DepositAttribute < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	set_table_name "mgd.deposdata"
	set_primary_key :eno
	named_scope :regname, :conditions => "attribname = 'REGNAME'"
	named_scope :minage_gp, :conditions => "attribname = 'MINAGE_GP'"
	named_scope :minsys_gp, :conditions => "attribname = 'MINSYS_GP'"
	named_scope :minsys_sgp, :conditions => "attribname = 'MINSYS_SGP'"
	named_scope :minsys_typ, :conditions => "attribname = 'MINSYS_TYP'"
	named_scope :classification, :conditions => "attribname = 'CLASSIFICATION'"
	named_scope :deposit_type, :conditions => "attribname = 'DEPOSIT TYPE'"

    set_date_columns :entrydate, :qadate, :lastupdate
end