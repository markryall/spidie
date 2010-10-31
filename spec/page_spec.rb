require File.dirname(__FILE__)+'/spec_helper'

describe "page retrieve" do
  before(:each) do
    @url = stub('url')
    @page_links = stub('links')
    @page = OpenStruct.new(:url => @url, :links => @page_links)

    @httpclient = stub("client")
    HTTPClient.stub!(:new).and_return @httpclient
    @http_content = stub('http_content')
    @http_header = stub('http_header')
    @http_result = stub('http_result', :content => @http_content, :header => @http_header)
    @httpclient.stub!(:get).with(@url).and_return @http_result
    
    @httpclient.stub(:head).with("http://www.google.com").and_return stub('http_result', :status =>200)

    @http_parser = stub('http_parser')
    HtmlParser.stub!(:new).and_return @http_parser
    @http_parser.stub!(:extract_links).and_return []
  end

  it "should retrieve a hearty page" do
    links = ["http://link1", "http://link2", "http://link3"]
    @http_result.stub(:status).and_return 200
    @http_parser.should_receive(:extract_links).with(@http_content).and_return links
    links.each do |link|
      linked_page = stub("linked page #{link}")
      Page.should_receive(:retrieve_or_create_page).with(link).and_return(linked_page)
      @page_links.should_receive(:<<).with(linked_page)
    end
    @page.should_receive(:visited=).with(true)
    Page.retrieve_links_for(@page)
  end

  [401, 404, 500].each do |status|
    it "should mark page as broken if status is #{status}" do
      @http_result.stub(:status).and_return status
      @http_parser.should_not_receive(:extract_links)
      @page.should_receive(:broken=).with(true)
      @page.should_receive(:visited=).with(true)
      Page.retrieve_links_for(@page)
    end
  end

  it 'should respectfully follow a 302' do
    redirect_url = stub('redirect_url')
    @http_result.stub(:status).and_return 302
    @http_header.should_receive(:[]).with('Location').and_return [redirect_url]
    @httpclient.should_receive(:get).with(redirect_url).and_return stub('http_redirect_response', :status => 401)
    @page.should_receive(:visited=).with(true).twice
    Page.retrieve_links_for(@page)
    @page.url.should == redirect_url
  end
  
  it 'should mark page as broken if connection is refused' do
     @httpclient.should_receive(:get).with(@url).and_raise Errno::ECONNREFUSED.new
     @page.should_receive(:broken=).with(true)
     @page.should_receive(:visited=).with(true)
     
     Page.retrieve_links_for(@page)
  end
  
  it 'should not mark page as broken and raise exception if connection is refused due to general network problems' do
    @httpclient.should_receive(:get).with(@url).and_raise Errno::ECONNREFUSED.new
    @httpclient.should_receive(:head).with("http://www.google.com").and_raise Errno::ECONNREFUSED.new
    
    @page.should_not_receive(:broken=).with(true)
    @page.should_not_receive(:visited=).with(true)
    expect{ Page.retrieve_links_for(@page)}.to raise_error(Errno::ECONNREFUSED)
  end

end