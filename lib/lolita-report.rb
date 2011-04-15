$:<<File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))
#require 'lolita'
require "lolita-report/configuration/base"
require "lolita-report/rails"
require "ruport"
require "spreadsheet"
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

Lolita::Navigation::Tree.after_branch_added do
  if self.name==:"left_side_navigation"
    if @last_branch && @last_branch.object && @last_branch.object.is_a?(Lolita::Mapping) 
      if @last_branch.object.to.lolita.reports.any?
        @last_branch.object.to.lolita.reports.each do |report|
          unless @last_branch.children.branches.detect{|b| b.options[:report_name]==report.name}
            @last_branch.append(report,:title=>report.title,:report_name=>report.name,:url=>Proc.new{
              send(lolita_resource_name(:action=>:reports,:plural=>true),:name=>report.name)
            })
          end
        end
      end
    end
  end
end
