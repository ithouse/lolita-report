require "lolita-report/routes"
Mime::Type.register "application/vnd.ms-excel", :xls
module LolitaReport
	class Engine < Rails::Engine
	end
end