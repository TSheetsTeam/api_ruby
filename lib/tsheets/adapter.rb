class TSheets::Adapter
  class << self
    def get(url, options)
      raise NotImplementedError
    end

    def post(url, data)
      raise NotImplementedError
    end

    def put(url, data)
      raise NotImplementedError
    end

    def delete(url, data)
      raise NotImplementedError
    end
  end
end
