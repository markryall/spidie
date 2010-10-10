Gem::Specification.load('gemspec').dependencies.each { |dep| gem dep.name, dep.requirement }

require 'gemesis/rake'
require 'resque/tasks'

task "resque:setup" => :environment

task :environment do
  $: << File.dirname(__FILE__)+'/lib'
  require 'spidie/job'
end


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

task :spec => [:clean] do
  sh 'spec spec'
end

desc 'clean'
task :clean do
  rm_rf 'tmp/test-spider-database'
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
task :start_spider => [:redis, :start_worker, :resque_web, :tail_spider] do
end

desc 'kill spider'
task :squash_spider do
  sh "ps auxw | grep 'resque:work\\|redis' | grep -v grep | awk '{print \$2}' |xargs kill -9"
end

 


