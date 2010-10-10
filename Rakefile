Gem::Specification.load('gemspec').dependencies.each { |dep| gem dep.name, dep.requirement }

require 'gemesis/rake'
require 'resque/tasks'

task "resque:setup" => :environment

task :environment do
  $: << File.dirname(__FILE__)+'/lib'
  require 'spidie/job'
end

task :spec => [:clean] do
  sh 'spec spec'
end

task :clean do
  rm_rf 'tmp/test-spider-database'
end

task :redis do
  sh "redis-server /usr/local/etc/redis.conf > redis.log 2>&1 &"
end

task :resque_web do
  puts "run resque-web with ruby - doesnt work with jruby. install it with `gem install resque"
end

task :resque_view do
  sh "open 'http://0.0.0.0:5678/overview'"
end

task :start_worker do
  sh "QUEUE=urls rake resque:work > worker.log 2>&1 &"
end

task :tail_spider do
  sh "tail -f redis.log worker.log"
end

task :start_spider => [:redis, :start_worker, :resque_web, :tail_spider] do
end

task :squash_spider do
  sh "ps auxw | grep 'resque:work\\|redis' | grep -v grep | awk '{print \$2}' |xargs kill -9"
end



task 


