$LOAD_PATH << File.expand_path("../../lib", __FILE__)

require 'jeweler'
require 'carmine/version'

Jeweler::Tasks.new do |gem|
  gem.name        = 'carmine'
  gem.version     = Carmine.version
  gem.email       = 'gsamokovarov@gmail.com'
  gem.authors     = ['Genadi Samokovarov']
  gem.license     = 'MIT'
  gem.summary     = 'Ruby client for pygmentize.me'
  gem.description = 'Ruby client for pygmentize.me'

  gem.add_dependency 'httparty'
end
