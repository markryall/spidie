require File.dirname(__FILE__)+'/spec_helper'

describe "report job" do
  before(:each) do
    clean_db
  end
  
  it "should report stuff" do
    Store.put Page.new("good_page", false)
    Store.put Page.new("broken_page", true)

    Neo4j::Transaction.run do
      Neo4j.number_of_nodes_in_use.should == 2
      PageNode.find('broken: true').size.should ==1
    end
  end
end