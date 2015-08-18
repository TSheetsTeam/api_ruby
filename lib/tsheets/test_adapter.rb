class TSheets::TestAdapter < TSheets::Adapter
  class << self
    def get(url, options, headers)
      "TEST ADAPTER RESPONSE - STUB ME OUT"
    end

    def post(url, data, options)
      OpenStruct.new({
        code: 200,
        to_str: JSON.dump({_status_extra: ''})
      })
    end

    def put(url, data, options)
      OpenStruct.new({
        code: 200,
        to_str: JSON.dump({_status_extra: ''})
      })
    end

    def delete(url, data, options)
      OpenStruct.new({
        code: 200,
        to_str: JSON.dump({_status_extra: ''})
      })
    end
  end
end
