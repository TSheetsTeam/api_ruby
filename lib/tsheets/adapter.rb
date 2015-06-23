class TSheets::Adapter
  class << self
    def get(url, options)
      raise NotImplementedError
    end
  end
end
