require 'support/fake_api'

module Helpers
  def fake_bridge
    TSheets::Bridge.new TSheets::Config.new
  end
end
