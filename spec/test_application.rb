require 'rubygems'
require 'sinatra'
require 'markaby'

File.open('tmp/test_web.pid', 'w') {|f| f.puts Process.pid }

get '/page_with_two_working_links_and_two_broken.html' do
  Markaby::Builder.new.html do
    head { title 'index.html' }
    body do
      ul {
        li { a 'a link', :href => 'http://localhost:4567/page_with_relative_links_one_fine_one_broken.html' }
        li { a 'a link', :href => 'http://localhost:4567/page_with_no_links.html' }
        li { a 'a broken link', :href => 'http://localhost:4567/broken_link.html' }
        li { a 'a bad hostname link', :href => 'http://localhost:11111/bad_hostname.html' }
      }
    end
  end
end

get '/page_with_no_links.html' do
  ''
end

get '/page_with_relative_links_one_fine_one_broken.html' do
  Markaby::Builder.new.html do
    head { title 'index.html' }
    body do
      ul {
        li { a 'a link', :href => '/working_relative_link_with_cyle.html' }
        li { a 'a link', :href => '/broken_relative_link.html' }
      }
    end
  end
end

get '/working_relative_link_with_cyle.html' do
  Markaby::Builder.new.html do
    head { title 'index.html' }
    body do
      ul {
        li { a 'a link', :href => '/page_with_two_working_links_and_two_broken.html' }
      }
    end
  end
end

