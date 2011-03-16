# Every class that include Lolita::Configuration this module assign
# #lolita and #lolita= methods. First one is for normal Lolita configuration
# definition, and the other one made to assing Lolita to class as a Lolita::Configuration::Base
# object. You may want to do that to change configuration or for testing purpose.
module LolitaReport
  module Configuration
    # Lolita could be defined inside of any class that is supported by Lolita::Adapter, for now that is
    # * ActiveRecord::Base
    # * Mongoid::Document
    # Main block can hold these methods:
    # <tt>list</tt> - List definition, see Lolitia::Configuration::List
    # <tt>tab</tt> - Tab definition, see Lolita::Configuration::Tab
    # <tt>tabs</tt> - Tabs definition, see Lolita::Configuration::Tabs
    class Base
      attr_reader :dbi,:klass
      @@generators=[:reports]
      class << self
        def add_generator(method)
          @@generators<<method.to_sym
        end
      end

      def initialize(orm_class,&block)
        @klass=orm_class
        @dbi=Lolita::DBI::Base.new(orm_class)
        block_given? ? self.instance_eval(&block) : self.generate!
      end
      
      #container for reports.(like array, but OBJECT)
      def reports &block
        Lolita::LazyLoader.lazy_load(self,:@reports,Lolita::Configuration::Reports,@dbi,&block)
      end

      def report *args, &block
        self.reports<<Lolita::Configuration::Report.new(@dbi,*args,&block)
      end
   
      
      # Call all supported instance metods to set needed variables and initialize object with them.
      def generate!
        @@generators.each{|generator|
          self.send(generator)
        }
      end
      
    end
  end
end