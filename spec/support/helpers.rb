require 'support/fake_api'
require 'tsheets/test_adapter'

module Helpers
  def fake_bridge
    config = TSheets::Config.new
    config.adapter = TSheets::TestAdapter
    TSheets::Bridge.new config
  end
end
