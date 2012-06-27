$:.unshift(File.join(File.dirname(__FILE__), 'spatial_adapter', 'lib'))

require 'rubygems'
require 'pp'
require 'active_record'
require 'active_record/connection_adapters/oracle_enhanced_adapter'
require 'geo_ruby'
require 'oci8'
require 'comma'
require 'utils/sdo_geometry.rb'

include GeoRuby::SimpleFeatures

#DB_CONFIG = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), 'database.yml'))


DB_CONFIG = YAML.load_file('config/database.yml')

# ============= Connect to oracle spatial development database =============
begin
  class DevDb < ActiveRecord::Base
    establish_connection(DB_CONFIG['development'])
    connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
  end
rescue Exception => e
  pp "#{e.message}: might I recommend SQL+ to fix this" if e.is_a?(OCISuccessWithInfo) 
  pp e.message
end

# ============= Connect to oracle spatial production database =============
begin
  class ProdDb < ActiveRecord::Base
    establish_connection(DB_CONFIG['production'])
    self.logger = Logger.new(STDOUT)
    connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
  end
rescue Exception => e
  pp "#{e.message}: might I recommend SQL+ to fix this" if e.is_a?(OCISuccessWithInfo) 
  pp e.message
end

#ActiveRecord::Base.connection.disable_dbms_output
# ==============================================================
# add spatial support from georuby and common spatial adapter
# These should be added AFTER the AR connection is established otherwise you will get
# "uninitialized constant ActiveRecord::..." error 
require 'common_spatial_adapter' # WARNING: MAKE SURE THIS IS AFTER AR CONNECTION IS ESTABLISHED
require 'lib/oracle_spatial_adapter'

# infections
#ActiveSupport::Inflector.inflections{|i| i.uncountable ['sampledata', 'data']}

#require 'lib/models/dev/sample'

#require 'lib/models/prod/entity'
#require 'lib/models/prod/entity'
#require 'lib/models/prod/survey'
#require 'lib/models/prod/sample'
#require 'lib/models/prod/sampledata'

