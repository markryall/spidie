Gem::Specification.load('gemspec').dependencies.each { |dep| gem dep.name, dep.requirement }

$: << File.dirname(__FILE__)+'/rake'

require 'gemesis/rake'
require 'resque/tasks'
require 'pids'
require 'httpclient'

# some aliases
task "a" => :acceptance_tests
task "c" => :clean

task "resque:setup" => :environment

task :environment do
  $: << File.dirname(__FILE__)+'/lib'
  require 'spidie/job'
  require 'spidie/report_job'
  require 'spidie/jobutils'
  Pids.persist 'tmp/spidie.pid'
end

task :check do
  redis_conf_file = "/usr/local/etc/redis.conf"
  redis_conf = open(redis_conf_file).read
  if redis_conf =~ /daemonize.*no/
    puts "you are not evil enough. set daemonize to yes in #{redis_conf_file}"
  end
end

task :default do
  sh "rake spec"
  sh "rake acceptance_tests"
end

desc 'run unit and integration tests'
task :spec => [:clean] do
  sh 'rspec spec'
end

desc 'clean'
task :clean => [:stop] do
  rm_rf 'tmp'
  mkdir_p 'tmp'
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

desc 'run acceptance tests, starts up spider and fake webserver first'
task :acceptance_tests => [:check, :clean, "test_web:start", "redis:start", "spidie:start"] do
  Pids.check_started "test_application.rb", lambda { HTTPClient.new.head("http://localhost:4567/page_with_two_working_links_and_two_broken.html").status == 200 }
  sh "rspec spec/end2end.rb"
end


Pids.create_tasks :name => :redis,
  :full_command => 'redis-server /usr/local/etc/redis.conf',
  :pid => '/usr/local/var/run/redis.pid'

Pids.create_tasks :name => :test_web,
  :command => 'ruby spec/test_application.rb'

Pids.create_tasks :name => :spidie,
  :command => "QUEUE=urls DOMAIN=localhost rake resque:work"
  
Pids.create_tasks :name => :spidie_prod,
  :command => "QUEUE=urls DOMAIN='qld.gov.au' rake resque:work"

desc 'starts spidie' 
task :start => ["redis:start", "spidie_prod:start"]

desc 'stops everything'
task :stop => ["redis:stop", "spidie:stop"]

desc 'enqueue task'
task :enqueue do 
   sh "bin/enspidie #{ENV['URL']}"
end

desc 'create a report'
task :report do 
   sh "bin/report" 
end
