$LOAD_PATH.unshift './lib'
require 'pry-developer_tools/version'

Gem::Specification.new do |s|
  s.name         = 'pry-developer_tools'
  s.version      = PryDeveloperTools::VERSION
  s.authors      = ["The Pry Team"]
  s.email        = 'rob@flowof.info'
  s.homepage     = 'https://github.com/pry/pry-developer_tools'
  s.summary      = 'A collection of developer tools for Pry users'  
  s.description  = s.summary

  s.files        = `git ls-files`.each_line.map(&:chomp)
  s.test_files   = Dir.glob "test/**/*.rb"

  s.platform = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  s.required_rubygems_version = '>= 1.3.6'

  s.add_runtime_dependency      'pry', '~> 0.9.8.pre'
  s.add_development_dependency 'rake'     , '~> 0.9.2'
end
