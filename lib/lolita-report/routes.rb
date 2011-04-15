module ActionDispatch::Routing
  class Mapper
    protected

    def lolita_report_route mapping, controllers
      # /categories/report/by-user-comments
      resources mapping.plural,:only=>[:none],:module=>mapping.module do
        collection do
          match "reports/:name", :to=>"#{controllers[:reports]}#show", :as=>"reports"
        end
      end
      
    end
  end
end