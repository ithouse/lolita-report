require "lolita-report/routes"
Mime::Type.register "application/vnd.ms-excel", :xls
module LolitaReport
	class Engine < Rails::Engine
    config.autoload_paths << File.expand_path("../../../app/reports", __FILE__)
	end
end