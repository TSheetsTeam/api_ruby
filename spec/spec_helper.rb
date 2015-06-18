require 'bundler/setup'
Bundler.setup

require 'tsheets'
require 'support/helpers'
require 'support/fake_api'

RSpec.configure do |config|
  config.include Helpers
end
