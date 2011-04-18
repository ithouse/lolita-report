$:<<File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))
#require 'lolita'
require "lolita-report/configuration/base"
require "lolita-report/rails"
require "ruport"
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
  self.branches.each do |branch|
    if branch.object.is_a?(Lolita::Mapping) && branch.object.to.lolita.reports.any?
      klass=branch.object.to
      klass.lolita.reports.each do |report|
        unless branch.children.branches.detect{|child_branch| child_branch.object==report}
          branch.append(report,:title=>report.title,:url=>Proc.new{|view,branch|
            
            options={:mapping=>branch.tree.parent.object,:action=>:reports,:plural=>true}
            path_method=view.send(:lolita_resource_name,options)
            view.send(path_method,:name=>branch.object.name)
          })
        end
      end
    end
  end
end
