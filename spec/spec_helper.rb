require 'cover_me'
require 'rubygems'
require 'abstract'
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
CoverMe.config do |c|
  # where is your project's root:
#  debugger
  puts "Project root=>"+c.project.root= File.expand_path('../../',__FILE__)

  # what files are you interested in coverage for:
  c.file_pattern # => /(#{CoverMe.config.project.root}\/app\/.+\.rb|#{CoverMe.config.project.root}\/lib\/.+\.rb)/i (default)

  # where do you want the HTML generated:
  c.html_formatter.output_path # => File.join(CoverMe.config.project.root, 'coverage') (default)

  # what do you want to happen when it finishes:

end


CoverMe.complete!


