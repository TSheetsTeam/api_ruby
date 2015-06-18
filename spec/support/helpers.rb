require 'support/fake_api'

module Helpers
  def fake_bridge
    TSheets::Bridge.new({})
  end
end
