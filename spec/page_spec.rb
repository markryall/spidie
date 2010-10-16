require File.dirname(__FILE__)+'/spec_helper'

describe "page retrieve" do
  before(:each) do
    @url = stub('url')
    @page = stub('page', :url => @url)
    @httpclient = stub("client")
    HTTPClient.should_receive(:new).and_return @httpclient
    @http_parser = stub('http_parser')
    HtmlParser.stub!(:new).and_return @http_parser
  end

  it "should retrieve a health page" do
    links = ["http://link1", "http://link2", "http://link3"]
    html = stub('html')
    http_result = stub('http_result', :content => html, :status => 200)

    @httpclient.should_receive(:get).with(@url).and_return http_result
    @http_parser.should_receive(:extract_links).with(html).and_return links
    @page.should_receive(:broken).and_return(false)
    links.each {|link| Page.should_receive(:new).with(:url => link, :broken => false)}

    Page.retrieve_links_for @page
  end

  it "should retrieve a broken page" do
    @httpclient.should_receive(:get).with(@url).and_return stub('result', :status => 404)
    @http_parser.should_not_receive(:extract_links)
    @page.should_receive(:broken=).with(true)
    @page.should_receive(:broken).and_return(true)

    Page.retrieve_links_for @page
  end
end