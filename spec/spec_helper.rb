$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'natives-catalog'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

module Natives
  module FixtureSupport
    def fixture_path
      RSpec.configuration.fixture_path
    end
  end
end

RSpec.configure do |config|
  config.add_setting :fixture_path
  config.fixture_path = File.join(File.dirname(__FILE__), 'fixtures')

  config.include Natives::FixtureSupport
end
