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
        @collumns_for_counting
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
      # generate excel file with necessary data and formating
      def export_excel
        book = Spreadsheet::Workbook.new
        sheet1=book.create_worksheet
        sheet1.name=@title_for_report if @title_for_report
        sheet1.row(0).replace(@table[0].attributes.map(&:to_s))
        1.upto(@table.size){|i|
          sheet1.row(i).replace(@table[0].attributes.collect{|f| @table[i-1].data[f]})
        }
        table_header_format_for sheet1
        set_columns_width_for sheet1
#        book.write "#{Time.now.to_i}.xls"
        book.write "test.xls"
      end

      private
      # set excel collumns width for sheet
      def set_columns_width_for sheet
        0.upto(@table[0].attributes.size-1){|i|
          sheet.column(i).width=20
        }
      end
      # make format for excel table header
      def table_header_format_for sheet
        title_format = Spreadsheet::Format.new :pattern_bg_color=>:grey,
          :weight => :bold,
          :size => 12
        sheet.row(0).default_format =title_format
      end
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
        @fields.size>0 if @fields
      end
      # Check if fields for counting are defined for report.
      def collumns_for_counting_defined?
        @collumns_for_counting.size>0 if @collumns_for_counting
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
