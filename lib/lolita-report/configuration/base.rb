# Every class that include Lolita::Configuration this module assign
# #lolita and #lolita= methods. First one is for normal Lolita configuration
# definition, and the other one made to assing Lolita to class as a Lolita::Configuration::Base
# object. You may want to do that to change configuration or for testing purpose.

module Lolita
  module Configuration

    class Base
      # Container for reports
      def reports &block
        Lolita::LazyLoader.lazy_load(self,:@reports,Lolita::Configuration::Reports,@dbi,&block)
      end

      # Container for report
      def report *args, &block
        self.reports<<Lolita::Configuration::Report.new(@dbi,*args,&block)
      end
    end
  end
end