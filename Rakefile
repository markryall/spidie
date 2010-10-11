Gem::Specification.load('gemspec').dependencies.each { |dep| gem dep.name, dep.requirement }

require 'gemesis/rake'
require 'resque/tasks'
require 'neo4j'

task "resque:setup" => :environment

task :environment do
  $: << File.dirname(__FILE__)+'/lib'
  require 'spidie/job'
end

task :default => [:spec, :acceptance_tests]

namespace :redis do
  desc 'start redis'
  task :start do
    puts "'daemonise yes' in /usr/local/etc/redis.conf or this task will block"
    system "redis-server /usr/local/etc/redis.conf"
  end

  desc 'stop redis'
  task :stop do
    system "kill #{File.read('/usr/local/var/run/redis.pid')}"
  end
end

task :agent do
end

task :spec => [:squash_spider, :clean] do
  sh 'spec spec'
end

desc 'clean'
task :clean do
  rm_rf 'tmp'
end

desc 'start redis'
task :redis do
  sh "redis-server /usr/local/etc/redis.conf > redis.log 2>&1 &"
end

desc 'how to start resque-web'
task :resque_web do
  puts "you can't use resque-web with jruby"
  puts "rvm use default; gem install resque; resque-web "
end

desc 'open resque-web page - u must first start it with ruby'
task :resque_view do
  sh "open 'http://0.0.0.0:5678/overview'"
end

task :start_worker do
  sh "QUEUE=urls rake resque:work > worker.log 2>&1 &"
end

desc 'tail spider logs'
task :tail_spider do
  sh "tail -f redis.log worker.log"
end

desc 'start spider'
task :start_spider => [:redis, :start_worker] do
end

desc 'kill spider'
task :squash_spider do
  sh "ps auxw | grep 'resque:work\\|redis' | grep -v grep | awk '{print \$2}' |xargs kill -9"
end

desc 'start fake webserver for returning web pages'
task :start_webserver do
  sh "ruby spec/test_application.rb > fake_webserver.log 2>&1 &"
end

desc 'run acceptance tests, starts up spider and fake webserver first'
task :acceptance_tests => [:squash_spider, :start_webserver, :start_spider,] do
  Rake::Task[:clean].execute
  sleep 10
  sh "spec spec/end2end.rb"
end

desc 'run acceptance tests assuming spider and fake webserver already running'
task :acceptance_tests_nostart do
  sh "spec spec/end2end.rb"
end
 


