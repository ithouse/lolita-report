module Lolita
  module Configuration
  autoload(:Reports,"lolita-report/configuration/reports")
  autoload(:Report,"lolita-report/configuration/report")
  require File.expand_path('../../../lolita/lib/lolita',__FILE__)
  end
end