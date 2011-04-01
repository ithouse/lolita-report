$:<<File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))
require 'lolita'
require "lolita-report/configuration/base"
require "lolita-report/rails"
module Lolita
  module Report
  
  end
  module Configuration
    autoload(:Reports,"lolita-report/configuration/reports")
    autoload(:Report,"lolita-report/configuration/report")
    #Lolita::Configuration::Base.send(:include,LolitaReport::Configuration)
  end
end
require "lolita-report/module.rb"
