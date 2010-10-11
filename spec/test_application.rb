require 'rubygems'
require 'sinatra'
require 'markaby'

get '/index.html' do
  Markaby::Builder.new.html do
      head { title 'index.html' }
      body do
        ul {
          li { a 'the link',:href => 'http://localhost:4567/index2.html' }
        }
      end
    end
end