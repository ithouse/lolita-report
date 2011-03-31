require 'lolita'
module Lolita
  module Configuration
    autoload(:Reports,"lolita-report/configuration/reports")
    autoload(:Report,"lolita-report/configuration/report")
#    require File.expand_path('../../../lolita/lib/lolita', __FILE__)
    require "lolita-report/configuration/base"
    #Lolita::Configuration::Base.send(:include,LolitaReport::Configuration)
    require 'spreadsheet'
    require 'ruport'
    Spreadsheet.client_encoding = 'UTF-8'
  end
end