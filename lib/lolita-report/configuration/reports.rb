module Lolita
  module Configuration
    class Reports
      #      include Lolita::Builder
      include Lolita::ObservedArray

      def initialize dbi,*args,&block
        @dbi=dbi
        @reports=[]
        self.instance_eval(&block) if block_given?
        #        self.set_attributes(*args)
      end
    
      def add *args,&block
        report=Lolita::Configuration::Report.new(@dbi,*args,&block)
        report.title=args[0]
        self<<report
      end

      def titles
        @reports.map(&:title)
      end

      def set_report_attributes(report)
        if report
          report.title="tab_#{@tabs.size}" unless report.title
        end
      end
   
      private
      def collection_variable
        @reports
      end
      def build_element(element,&block)
        current_report=if element.is_a?(Hash) || element.is_a?(Symbol)
          Lolita::Configuration::Tab.new(@dbi,element,&block)
        else
          element
        end
        #        set_report_attributes(current_report)
        #        validate_type(current_report)
        current_report
      end
      
    end
  end
end