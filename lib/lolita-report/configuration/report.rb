# Lolita::Configuration::Report class contain methods for generating report

module Lolita
  module Configuration
    class Report
      include Lolita::Builder
      
      lolita_accessor :title,:name,:total_columns, :table,:fields
      
      def initialize(dbi,title=nil, &block)
  
        @dbi=dbi
        @fields=[]
        @title=title
        self.instance_eval(&block) if block_given?
        raise ArgumentError, "Report must have title" unless @title
        set_default_values
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
      def name value=nil
        @name=value if value
        @name
      end

      def field *args, &block
        @fields<<Lolita::Configuration::Field::Base.new(@dbi,*args,&block)
      end

      def fields *args
        if args
          @fields=[]
          args.each{|f| field(f)}
        end
        @fields
      end

      def file_name ext
        "#{self.title} at #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}.#{ext}"
      end

      # Return fields for displaying in report.
      def custom_fields
        @fields if @fields
      end

      # Generate table for report, which contain all necessary data
      def generate_table_for_report
        self.create_table
        add_collumns_for_counting if collumns_for_counting_defined?
        self.collect_data
        @table
      end

      # generate excel file with necessary data and formating
      def to_xls response_type=:raw
        book = Spreadsheet::Workbook.new
        sheet1=book.create_worksheet
        sheet1.name=self.title
        sheet1.row(0).replace(@table[0].attributes.map(&:to_s))
        1.upto(@table.size){|i|
          sheet1.row(i).replace(@table[0].attributes.collect{|f| @table[i-1].data[f]})
        }
        table_header_format_for sheet1
        set_columns_width_for sheet1
        if response_type==:raw
          blob = StringIO.new("")
          book.write blob
          blob.string
        else
          book.write self.file_name(:xls)
        end
      end

      protected

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
      def create_table
        @table = Table @fields.map{|f| f.title}
      end

      # Set all necessary data into table.
      def collect_data
        field_names=@fields.map{|f| f.name}
        @dbi.find(:all).each{|record|
          @table<<field_names.map{|f_name|
            record.send(f_name)
          }
        }
      end

      # Set necessary data in columns, where will bi counting something.
      def set_data_in_counting_columns object
        @collumns_for_counting.each{|method|
          @hsh["#{method.to_s}_total"]=object.send(method).size
        }
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
