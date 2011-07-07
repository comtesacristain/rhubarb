class DepositStatus < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")

	set_table_name "mgd.deposits"
	set_primary_key :eno


	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :eno

	named_scope :state, lambda { |s| { :conditions=> ["state = ?", s] } }

	def self.atlas_statuses
    ['operating mine','mineral deposit','historic mine']
  end

  def self.states
    {}
  end


	set_date_columns :entrydate, :qadate, :lastupdate
end
