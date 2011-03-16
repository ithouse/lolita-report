# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Lolita::Configuration::Reports do
  before(:each) do
    @dbi=Lolita::DBI::Base.new(Post)
  end

  it "should create new reports container" do
    reports=Lolita::Configuration::Reports.new(@dbi)
    reports.size.should == 0
  end
  it "should create new container when block given" do
    reports=Lolita::Configuration::Reports.new(@dbi){}
    reports.size.should == 0
  end
  it "should add new report" do
    reports=Lolita::Configuration::Reports.new(@dbi)do
      add("new report")
    end
    reports.first.title.should == "new report"
  end
  it "should add reports" do
    reports=Lolita::Configuration::Reports.new(@dbi)
    reports.add("report_1")
    reports<<"report_2"
    reports<<Lolita::Configuration::Report.new(@dbi,"report_3")
    reports.size.should == 3
  end
  it "should return titles for all reports" do
    reports=Lolita::Configuration::Reports.new(@dbi) do
      add("new_report")
    end
    reports.titles.size.should == 1
    reports.titles.first.should == "new_report"
  end
end

