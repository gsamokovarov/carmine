$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'carmine'
require 'rspec'

RSpec.configure do |config|
  config.fail_fast = true
end
