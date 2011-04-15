class Lolita::ReportsController < ApplicationController
  include Lolita::Controllers::InternalHelpers
  layout "lolita/application"
  def show
    report = self.resource_class.lolita.reports.by_name(params[:name])
    report.generate_table_for_report
    respond_to do |format|
      format.html{
        @builder=report.build 
        render
      }
      format.xls do |format|
        xls=report.to_xls(:raw)
        send_data xls, :type => :xls, :filename => report.file_name(:xls)
      end
    end
  end
end