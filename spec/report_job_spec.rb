require File.dirname(__FILE__)+'/spec_helper'

describe "report job" do
  include Store

  before do
    clean_db
  end

  it "should report stuff" do
    while_shopping do
      Page.new :url => "good_page", :broken => false
      Page.new :url => "broken_page", :broken => true
    end

    while_shopping do
      pages.count.should == 2
      broken_pages.count.should ==1
    end
  end
end