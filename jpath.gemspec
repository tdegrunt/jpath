# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "jpath"
  s.version     = "0.1"
  s.authors     = ["Alex Serebryakov"]
  s.email       = ["alex@merimond.com"]
  s.homepage    = "https://github.com/merimond/jpath"
  s.summary     = %q{XPath queries for JSON documents}
  s.description = %q{JPath is a Ruby library that allows to execute XPath queries on JSON documents}
  
  s.rubyforge_project = "jpath"
  s.add_development_dependency "rspec"
  
  s.test_files    = Dir['{spec}/**/*']
  s.files         = Dir['{lib}/**/*', 'Rakefile', 'README*', 'LICENSE']
  s.require_paths = ["lib"]
end
