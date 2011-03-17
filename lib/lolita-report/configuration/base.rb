# Every class that include Lolita::Configuration this module assign
# #lolita and #lolita= methods. First one is for normal Lolita configuration
# definition, and the other one made to assing Lolita to class as a Lolita::Configuration::Base
# object. You may want to do that to change configuration or for testing purpose.
module LolitaReport
  module Configuration
      #container for reports.(like array, but OBJECT)
      def reports &block
        Lolita::LazyLoader.lazy_load(self,:@reports,Lolita::Configuration::Reports,@dbi,&block)
      end

      def report *args, &block
        self.reports<<Lolita::Configuration::Report.new(@dbi,*args,&block)
      end
  end
end