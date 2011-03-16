require 'rubygems'
require 'ruport'
require 'spreadsheet'
require 'stringio'

Spreadsheet.client_encoding = "UTF-8"

#
# This module provides Spreadsheet support via the +spreadsheet+ gem. Its
# primary interface is the +to_excel+ method on Ruport::Data::Table.
#
# = Options for +to_excel+:
#
# * workbook: use this to provide a workbook you've already created (or was
#   passed back to you, see below). A new sheet will be created.
# * worksheet_name: Name the new worksheet.
# * show_table_headers: when set true, turns the first item in the parsed
#   table into a header with additional formatting.
# * format_options: header format options.
# * file: write to this filename. Writing is performed by Spreadsheet, not
#   Ruport.
# * to_string: yields a string containing the written Spreadsheet for further
#   processing.
#
# If +to_string+ and +file+ are not provided, the workbook is returned for
# further processing.
#
# = Creating multiple workbooks
#
# Refer to the Ruport documentation for working with tables.
#
# Here ya go:
#
#   t = Table.parse("some,csv,data")
#   t2 = Table.parse("other,csv,data")
#
#   book = t.to_excel(:worksheet_name => "Hello!")
#   t2.to_excel(:workbook => book, :file => "myworkbook.xls")
#
# Will create a +myworkbook.xls+ in your current directory with two worksheets:
# the first containing the "some,csv,data" data, and the second containing the
# "other,csv,data" reporting information. The first worksheet will be named,
# "Hello!" while the second will be named the very boring "Worksheet 2".
#

class Ruport::Formatter::Excel < Ruport::Formatter
  renders :excel, :for => Ruport::Controller::Table

  def output
    if options.workbook
      book = options.workbook
    else
      book = Spreadsheet::Workbook.new
    end

    if options.worksheet_name
      book_args = { :name => options.worksheet_name }
    else
      book_args = { }
    end

    sheet = book.create_worksheet(book_args)

    offset = 0

    if options.show_table_headers
      sheet.row(0).default_format = Spreadsheet::Format.new(
        options.format_options ||
          {
          :color => :blue,
          :weight => :bold,
          :size => 18
        }
      )
      sheet.row(0).replace data.column_names
      offset = 1
    end

    data.data.each_with_index do |row, i|
      sheet.row(i+offset).replace row.attributes.map { |x| row.data[x] }
    end

    if options.file
      return book.write options.file
    elsif options.to_string
      retval = StringIO.new
      book.write retval
      retval.seek(0)
      return retval.read
    end

    return book
  end
end