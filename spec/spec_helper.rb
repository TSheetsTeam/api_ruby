require 'bundler/setup'
Bundler.setup

require 'pry'

require 'tsheets'
require 'support/helpers'
require 'support/fake_api'

RSpec.configure do |config|
  config.include Helpers
end
