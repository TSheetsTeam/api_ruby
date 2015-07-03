class TSheets::TestAdapter < TSheets::Adapter
  class << self
    def get(url, options)
      "TEST ADAPTER RESPONSE - STUB ME OUT"
    end

    def post(url, data, options)
      true
    end
  end
end
