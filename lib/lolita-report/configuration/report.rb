# Lolita::Configuration::Report class contain methods for generating report

module Lolita
  module Configuration
    class Report
      #include Lolita::Builder
      
      lolita_accessor :title,:name,:class_name,:file_base_name,:controller
      attr_writer :column_names

      def initialize(dbi,title=nil, &block)
  
        @dbi=dbi
        @column_names=[]
        @title=title
        self.instance_eval(&block) if block_given?
        raise ArgumentError, "Report must have title" unless @title
        set_default_values
      end

      def report_controller
        @controller || ::DefaultReport
      end

      def column_names *args
        if args && args.any?
          @column_names=args
        end
        @column_names
      end

      def save_in_file?
        !!@file_base_name
      end

      def file_name(ext)
        "#{@file_base_name||"#{self.name}"}_#{Time.now.strftime("%Y%m%d%H%M%S")}.#{ext}"
      end
    
      def klass
        @klass||=if self.class_name
          Lolita::DBI::Base.new(self.class_name.constantize)
        else
          @dbi
        end
        @klass
      end
      
      private

      def set_default_values
        @name||="report_for_#{dbi.class.to_s}_#{self.__id__}"
      end

      class << self
        def formats
          [:xls]
        end
      end

    end
  end
end
