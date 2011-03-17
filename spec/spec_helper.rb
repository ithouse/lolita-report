require 'rubygems'
require 'abstract'
require 'ruport'
require 'factory_girl_rails'
require File.dirname(__FILE__) + "/factories/factories"
LOLITA_ORM=:mongoid
require "orm/#{LOLITA_ORM}"
require File.expand_path(File.dirname(__FILE__) + '/../lib/lolita-report')

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

