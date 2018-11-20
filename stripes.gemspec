$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'stripes/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'stripes'
  s.version     = Stripes::VERSION
  s.authors     = ['Svetlozar Mihailov']
  s.email       = ['svetliomihailov@gmail.com']
  s.homepage    = ''
  s.summary     = ''
  s.description = ''
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.2.1'

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'sqlite3'
end
