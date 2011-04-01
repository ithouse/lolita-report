class ReportsController < ApplicationController
  include Lolita::Controllers::InternalHelpers

  def report
    debugger
    report = self.resource_class.lolita.report.by_id(params[:id])
    report.generate_table_for_report
    builder=build_response_for(:report)
    render_component *builder
  end
end