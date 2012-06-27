class DepositStatus < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")

	set_table_name "mgd.deposits"
	set_primary_key :eno
  
  #belongs_to :zone, :class_name => "Zone",  :foreign_key => :parent

	belongs_to :deposit, :class_name => "Deposit", :foreign_key => :eno

  scope :state, lambda { |s| where(:state=>s) }
  scope :status, lambda { |s| where(:operating_status=>s) }

	def self.statuses
    return ActiveSupport::OrderedHash["All",nil,"Operating Mines","operating mine","Historic Mines","historic mine","Mineral Deposits","mineral deposit"]
  end

  def self.atlas_statuses
    return ActiveSupport::OrderedHash["Operating Mines","operating mine","Historic Mines","historic mine","Mineral Deposits","mineral deposit"]
  end

  def self.states
    {}
  end

	set_date_columns :entrydate, :qadate, :lastupdate
end
