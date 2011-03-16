require 'rubygems'
require 'abstract'
require 'ruport'
require 'factory_girl_rails'
require File.dirname(__FILE__) + "/factories/factories"
LOLITA_ORM=:mongoid
require "orm/#{LOLITA_ORM}"
require File.expand_path(File.dirname(__FILE__) + '/../lib/lolita-report')
require File.expand_path(File.dirname(__FILE__) + '/../lib/lolita-report/dbi/base')
require File.expand_path(File.dirname(__FILE__) + '/../lib/lolita-report/adapter/abstract_adapter')
#require File.expand_path(File.dirname(__FILE__) + '/../lib/lolita-report/adapter/active_record')
require File.expand_path(File.dirname(__FILE__) + '/../lib/lolita-report/adapter/mongoid')
require File.expand_path(File.dirname(__FILE__) + '/../lib/lolita-report/builder')
require File.expand_path(File.dirname(__FILE__) + '/../lib/lolita-report/observed_array')
require File.expand_path(File.dirname(__FILE__) + '/../lib/lolita-report/ruby_ext/accessors')

RSpec.configure do |config|
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
  if LOLITA_ORM==:active_record
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
  end
end

