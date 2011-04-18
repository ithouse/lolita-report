class DefaultReport < Ruport::Controller
  required_option :report
  stage :header,:body,:footer
  finalize :report
  
  def setup
    self.data=Ruport::Table(
      :column_names=>options.report.column_names.map{|n| n.to_s.humanize},
      :data=>collect_data(options.report.column_names)
    )
  end
 

  def collect_data(column_names)
    options.report.klass.find(:all).map{|record|
      column_names.map{|column_name|
        record.send(column_name.to_sym)
      }
    }
  end

  formatter :html do
    build :header do
      output << "<div class='box list'><h1 class='black'>&nbsp#{options.report.title}</h1>"
      output << "<table><thead>"
      data.column_names.each do |column_name|
        output << "<th>#{column_name}</th>"
      end
      output << "</thead>"
    end

    build :body do
      output << "<tbody>"
      data.data.each{|row|
        output << "<tr>#{row.inject(""){|result,f| result<<"<td>#{f}</td>"}}</tr>"
      }
      output << "</tbody>"
    end

    build :footer do
      output << "</table>"
      output << "</div>"
    end
  end
end

class XLS < Ruport::Formatter
  renders :xls, :for=>DefaultReport

  def initialize 
    require "spreadsheet"
    @book = Spreadsheet::Workbook.new
    @sheet=@book.create_worksheet
  end

  def build_header
    @sheet.name=options.report.title
    @sheet.row(0).replace(options.report.column_names.map{|c| c.to_s})
    @sheet.row(0).default_format=header_format()
    0.upto(options.report.column_names.size-1) do |index|
      @sheet.column(index).width=20
    end
  end

  def build_body
    data.data.each_with_index do |row,index|
      @sheet.row(index+1).replace(row.map{|c| c.to_s})
    end
  end

  def finalize_report
    if options.report.save_in_file?
      @book.write(options.report.file_name(:xls))
    else
      blob = StringIO.new("")
      @book.write blob
      output << blob.string
    end
  end

  private

  def header_format
    Spreadsheet::Format.new(
      :pattern_bg_color=>:grey,
      :weight => :bold,
      :size => 12
    )
  end
end