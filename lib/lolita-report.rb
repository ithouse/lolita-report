require 'lolita'
module Lolita
  module Configuration
    autoload(:Reports,"lolita-report/configuration/reports")
    autoload(:Report,"lolita-report/configuration/report")
    require "lolita-report/configuration/base"
    #Lolita::Configuration::Base.send(:include,LolitaReport::Configuration)
    
  end
end