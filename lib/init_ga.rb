#require File.join('utils', 'mars_helper.rb')
require File.join('lib', 'sdo_geometry.rb')
require File.join('lib', 'oci8_hack.rb')
require File.join('lib', 'identified_resource.rb')
require File.join('lib', 'resource_class.rb')
require File.join('lib', 'gmap_polyline_encoder.rb')
require File.join('lib', 'as_polyline.rb')
#require File.join('utils', 'schema_dev.rb')
#require 'comma'
#require 'csv'
#require 'haml'
#require 'spreadsheet'
#require 'gchart'
include GeoRuby::SimpleFeatures
require File.join('lib', 'array')
ENV['http_proxy']="http://u10301:omholdings@proxy.ga.gov.au:8080"