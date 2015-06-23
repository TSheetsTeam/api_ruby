require 'rest-client'

class TSheets::RestAdapter < TSheets::Adapter
  class << self
    def get(url, options)
      RestClient.get url, options
    end
  end
end
