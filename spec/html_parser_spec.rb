require File.dirname(__FILE__)+'/spec_helper'

require 'spidie/html_parser'

describe Spidie::HtmlParser do
  it 'should find no links in nil document' do
    Spidie::HtmlParser.new('').extract_links(nil).should == []
  end

  it 'should find no links in empty document' do
    Spidie::HtmlParser.new('').extract_links(nil).should == []
  end

  it 'should find links in document with absolute urls' do
    Spidie::HtmlParser.new('http://bar').extract_links('<a href="http://foo/index.html"></a><a href="http://bar/index.html"></a>').should == ["http://foo/index.html","http://bar/index.html" ]
  end

  it 'should convert simple relative links to absolute' do
    Spidie::HtmlParser.new('http://www.google.com').extract_links('<a href="index.html"></a>').should  == ['http://www.google.com/index.html']
  end
  
  it 'should convert simple relative links to absolute' do
    Spidie::HtmlParser.new('http://www.google.com/').extract_links('<a href="/index.html"></a>').should  == ['http://www.google.com/index.html']
  end

  it 'should convert simple relative links to absolute' do
    Spidie::HtmlParser.new('http://www.google.com/a/b/c.cgi?a=b').extract_links('<a href="/c/d/index.html"></a>').should == ['http://www.google.com/c/d/index.html']
  end
  
  it 'should not convert mangled links' do
    Spidie::HtmlParser.new("http://www.qld.gov.au/").extract_links('<a href="/some garbage"></a>').should  == ["/some garbage"]
  end
  
  it 'should trim spaces' do
    Spidie::HtmlParser.new("http://www.qld.gov.au").extract_links('<a href=" /thing.html "></a>').should  == ["http://www.qld.gov.au/thing.html"]
    Spidie::HtmlParser.new("http://www.qld.gov.au").extract_links('<a href=" http://bla/thing.html "></a>').should  == ["http://bla/thing.html"]
  end
    
end