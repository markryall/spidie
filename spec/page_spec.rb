require File.dirname(__FILE__)+'/spec_helper'

describe "page retrieve" do
  before(:each) do
    ENV['DOMAIN'] = ""
    new_tx
    
    @url = "url"
    @page = Page.new :url => @url

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
  
  after(:each) do
    rollback_tx
  end

  it "should retrieve a hearty page" do
    @http_result.stub(:status).and_return 200
    @page.should_receive(:populate_links).with(@http_content)
    
    @page.get_content_and_populate_links
    
    @page.url.should == @url
    @page.broken.should == false
    @page.visited.should == true  
  end
  
  it "should populate links" do
    links = ["link1", "link2"]
    @http_parser.should_receive(:extract_links).with(@http_content).and_return links
    
    @page.populate_links @http_content
    
    @page.links.map{|p| p.url}.should =~ links
  end
  
  it "should not store a link to itself" do
    @http_parser.should_receive(:extract_links).with(@http_content).and_return ["link1", @url]
    
    @page.populate_links @http_content
    
    @page.links.map{|p| p.url}.should =~ ["link1"]
  end
  
  it "should not store links to sites outside of the search domain" do
    ENV['DOMAIN'] = "qld.gov.au"
    
    links = ["http://foo.com/sdf", "https://bla.qld.gov.au/sdfd"]
    @http_parser.should_receive(:extract_links).with(@http_content).and_return links
    
    @page.populate_links @http_content
    
    @page.links.map{|p| p.url}.should =~ ["https://bla.qld.gov.au/sdfd"]
  end

  [401, 404, 500].each do |status|
    it "should mark page as broken if status is #{status}" do
      @http_result.stub(:status).and_return status
      @http_parser.should_not_receive(:extract_links)
      
      @page.get_content_and_populate_links
      
      @page.broken.should == true
      @page.visited.should == true
    end
  end

  it 'should respectfully follow a 302' do
    pending
    redirect_url = stub('redirect_url')
    @http_result.stub(:status).and_return 302
    @http_header.should_receive(:[]).with('Location').and_return [redirect_url]
    @httpclient.should_receive(:get).with(redirect_url).and_return stub('http_redirect_response', :status => 401)

    @page.get_content_and_populate_links
    @page.url.should == redirect_url
    @page.broken.should == false
    @page.visited.should == true
  end
  
  it 'should mark page as broken if there is a connection exception' do
     @httpclient.should_receive(:get).with(@url).and_raise Exception.new
     
     @page.get_content_and_populate_links
     
     @page.broken.should == true
     @page.visited.should == true
  end
  
  it 'should not mark page as broken and raise exception if connection is refused due to general network problems' do
    @httpclient.should_receive(:get).with(@url).and_raise Exception.new
    @httpclient.should_receive(:head).with("http://www.google.com").and_raise Exception.new

    expect{ @page.get_content_and_populate_links}.to raise_error(Exception)
    
    @page.broken.should == false
    @page.visited.should == false
  end
end
