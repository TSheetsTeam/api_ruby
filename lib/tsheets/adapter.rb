class TSheets::Adapter
  class << self
    def get(url, options)
      raise NotImplementedError
    end

    def post(url, data, options)
      raise NotImplementedError
    end

    def put(url, data, options)
      raise NotImplementedError
    end

    def delete(url, data, options)
      raise NotImplementedError
    end
  end
end
