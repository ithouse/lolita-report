# Lolita::Configuration::Report class contain methods for generating report

module Lolita
  module Configuration
    class Report

      lolita_accessor :title,:total_columns
      
      def initialize(dbi,title=nil, &block)
        @dbi=dbi
        @fields=[]
        self.title=title
        self.instance_eval(&block) if block_given?
      end
      
      # Set data for counting.
      def total(*args)
        @collumns_for_counting=args if args
      end
      # Return columns in array, which are needed counted.
      def total_columns
        @collumns_for_counting
      end

      # Set a title for report.
      def name title
        if title
          @title_for_report=title
        else
          @title_for_report=""
        end
      end

      # Set fields for displaying in report.
      def fields(*args)
        @fields=args if args
        @fields
      end

      # Return fields for displaying in report.
      def custom_fields
        @fields if @fields
      end

      # Generate table for report, which contain all necessary data
      def generate_table_for_report
        create_table_for_report if fields_defined?
        add_collumns_for_counting if collumns_for_counting_defined?
        set_data_into_table_for_report
        @table
      end
      
      private
      # Make table,which contain all necessary data for report.
      def create_table_for_report
        @table = Table @fields
      end
      # Set all necessary data into table.
      def set_data_into_table_for_report
        @dbi.find(:all).each{|object|
          @hsh={}
          @fields.each{|f|
            @hsh[f]=object.send(f)
            set_data_in_counting_columns(object) if collumns_for_counting_defined?
          }
          @table<<@hsh
        }
      end
      # Set necessary data in columns, where will bi counting something.
      def set_data_in_counting_columns object
        @collumns_for_counting.each{|method|
          @hsh["#{method.to_s}_total"]=object.send(method).size
        }
      end
      # Check if fields are defined for report.
      def fields_defined?
        @fields.size>0
      end
      # Check if fields for counting are defined for report.
      def collumns_for_counting_defined?
        @collumns_for_counting.size>0
      end
      # For setting data for cuonting, necessary to add this collumns to table.
      def add_collumns_for_counting
        @collumns_for_counting.each{|method|
          @table.add_column("#{method.to_s}_total",:default=>0) if @table
        }
      end
    end
  end
end
