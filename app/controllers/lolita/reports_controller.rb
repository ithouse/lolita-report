class Lolita::ReportsController < ApplicationController
  include Lolita::Controllers::InternalHelpers
  layout "lolita/application"
  def show
    @report = self.resource_class.lolita.reports.by_name(params[:name])
    respond_to do |format|
      format.html{
        @html=@report.report_controller.render_html(:report=>@report)
        render
      }
      format.xls do |format|
        xls=@report.report_controller.render_xls(:report=>@report)
        unless @report.file_base_name
          send_data xls,:type=>:xls,:filename=>@report.file_name(:xls)
        end
      end
    end
  end
end