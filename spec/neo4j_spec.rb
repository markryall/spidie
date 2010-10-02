require File.dirname(__FILE__)+'/spec_helper'


Neo4jr::Configuration.database_path = File.join(File.expand_path(File.dirname(__FILE__)), 'test-spider-database')

describe "spider database" do
  it 'should store a page by url' do
    url = 'http://www.google.com'

    page = Spidie::Page.new(url)
    Spidie::Store.put(page)

    found_page = Spidie::Store.retrieve(url)
    found_page.url.should == url
  end
end