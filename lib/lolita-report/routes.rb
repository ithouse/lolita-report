module ActionDispatch::Routing
  class Mapper
    protected

    def lolita_report_route mapping, controllers
      # /categories/report/by-user-comments
      resources mapping.plural,:only=>[:none],
        :controller=>controllers[:reports],:module=>mapping.module do
          member do
            get "report"
          end
        end
      
    end
  end
end