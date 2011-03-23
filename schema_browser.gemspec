lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'schema_browser/version'

Gem::Specification.new do |s|
  s.name        = "schema_browser"
  s.version     = SchemaBrowser::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tom ten Thij"]
  s.email       = ["ruby@tomtenthij.nl"]
  s.homepage    = "http://github.com/tomtt/schema_browser"
  s.summary     = "A tool to help you display the model schema of a rails project"
  s.description = "Including this gem in a rails project will allow you to export a graphical representation of your model schema."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "rspec"
  s.add_development_dependency "ruby-debug"
  s.add_development_dependency "term-ansicolor"
  s.add_development_dependency "ZenTest"
  s.add_development_dependency "grog"

  s.files        = Dir.glob("{bin,lib}/**/*") + %w{MIT-LICENSE}
  s.require_path = 'lib'
end
