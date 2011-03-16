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
      def total(*args)
        @collumns=args
        @total=args if args
        @total
      end
      def total_columns
        @collumns
      end
      def fields(*args)
        @fields=args if args
        @fields
      end
      def custom_fields
        @fields
      end
      #pievienojam jaunas kolonnas ja vajag kautko saiskaitit
#      def add_column_for_counting
#        if @total.size>0
#          @total.each{|count|@table.add_column("#{count.to_s}_total",:default=>99999) if @table
#          }
#        end
#      end
      def generate_html
        @table = Table @fields
        #        add_collumn_for_counting
        if @total.size>0
          @total.each{|count|@table.add_column("#{count.to_s}_total",:default=>99999) if @table
          }
        end
        @dbi.klass.all.each{|model|
          hsh={}
          @fields.each{|f|
            hsh[f]=model.send(f)
            if @total.size>0
              @total.each{|count|
                hsh["#{count.to_s}_total"]=model.send(count).size
              }
            end
          }
          @table<<hsh
        }
        debugger
        @table
      end
    end
  end
end