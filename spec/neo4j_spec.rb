require File.dirname(__FILE__)+'/spec_helper'
require 'neo4jr-simple'

Neo4jr::Configuration.database_path = File.join(File.expand_path(File.dirname(__FILE__)), 'test-spider-database')

describe "spider database" do
  it 'should store a page by url' do
    
    page = Page.new(url)
    Spidie::Store.put(page)
    
    found_page = Spidie::Store.retrieve(url)
    found_page.url.should == url
    
=begin
    url = 'http://link'
       
       Neo4jr::DB.execute do |neo|
         node = neo.createNode
         node[:identifier] = url
       end

       found_node = Neo4jr::DB.execute do |neo|
         neo.find_node_by_identifier(url)
       end
       
       found_node[:identifier].should == url
=end
   

  end
end