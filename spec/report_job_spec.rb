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

    Neo4j::Transaction.run do
      Neo4j.number_of_nodes_in_use.should == 3
      Page.find('broken: true').size.should ==1
    end
  end
end