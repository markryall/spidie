Gem::Specification.new do |spec|
  spec.name = 'spidie'
  spec.version = '0.0.1'
  spec.summary = 'An experimental web spider gem'
  spec.description = <<-EOF
Once in each lifetimes there comes a web spider that supercedes the expectations of those who have fine and delicate tastes about such things as web spiders.

This is not that spider.
EOF

  spec.authors << 'Mark Ryall'
  spec.email = 'mark@ryall.name'
  spec.homepage = 'http://github.com/markryall/spidie'
 
  spec.files = Dir['lib/**/*'] + Dir['bin/*'] + ['README.rdoc', 'MIT-LICENSE']
  spec.executables << 'enspidie'

  spec.add_development_dependency 'jruby-openssl', '~>0.7.1'
  spec.add_development_dependency 'rake', '~>0.8.7'
  spec.add_development_dependency 'gemesis', '~>0.0.3'
  spec.add_development_dependency 'rspec', '~>1.3.0'

  spec.add_dependency 'resque', '~>1.10.0'
  spec.add_dependency 'nokogiri', '~>1.4.3.1'
  spec.add_dependency 'neo4j', '~>0.4.6'
end