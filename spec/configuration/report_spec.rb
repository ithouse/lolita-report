# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Lolita::Configuration::Report do
  before(:each) do
    @dbi=Lolita::DBI::Base.new(Post)
  end

  it "should create report" do
    report=Lolita::Configuration::Report.new(@dbi,"new_report")
    report.title.should == "new_report"
  end

  it "should create report when block given" do
    report=Lolita::Configuration::Report.new(@dbi) do
      title("new_report")
    end
    report.title.should == "new_report"
  end

  it "should create report with custom fields " do
    report=Lolita::Configuration::Report.new(@dbi,"new_report") do
      fields(:title,:content)
    end
    report.custom_fields.size.should==2
  end

  it "should create report with summon comments" do
    report=Lolita::Configuration::Report.new(@dbi,"new_report") do
      total(:comments)
    end 
    report.total_columns.size.should==1
  end
  
  it "should generate report about post's comments count" do
    post_1=Factory.create(:post,:title=>"pirma raksta virsraksts",:content=>"pirma raksta saturs")
    post_2=Factory.create(:post,:title=>"otra raksta virsraksts",:content=>"otra raksta saturs")
    post_3=Factory.create(:post,:title=>"tresa raksta virsraksts",:content=>"tresa raksta saturs")
    comment_1=Factory.create(:comment)
    comment_2=Factory.create(:comment)
    comment_3=Factory.create(:comment)
    post_1.comments<<comment_1
    post_2.comments<<comment_2
    post_2.comments<<comment_3
    report=Lolita::Configuration::Report.new(@dbi) do
      name("post's comments count")
      fields(:title,:content)
      total(:comments)
    end
    report.generate_table_for_report

    post_1.destroy
    post_2.destroy
    post_3.destroy
    comment_1.destroy
    comment_2.destroy
    comment_3.destroy
  end
  it "should export excel file for report" do
    post_1=Factory.create(:post)
    post_2=Factory.create(:post)
    report=Lolita::Configuration::Report.new(@dbi) do
      fields(:title,:content)
      total(:comments)
    end
    report.generate_table_for_report
    report.export_excel
    post_1.destroy
    post_2.destroy
    # Reading generated Excel file
    Spreadsheet.client_encoding = 'UTF-8'
    book=Spreadsheet.open "test.xls"
    sheet1 = book.worksheet 0
    table_head=sheet1.row(0)
    table_head[0].should == "title"
    table_head[1].should == "content"
    table_head[2].should == "comments_total"
    data=sheet1.row(1)
    data[0].nil?.should == false
    data[1].nil?.should == false
    data[2].nil?.should == false
    data[3].nil?.should == true
  end
end

