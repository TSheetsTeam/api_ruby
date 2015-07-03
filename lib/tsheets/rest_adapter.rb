require 'rest-client'

class TSheets::RestAdapter < TSheets::Adapter
  class << self
    def get(url, options)
      RestClient.get url, options
    end

    def post(url, data, options)
      RestClient.post url, data, options
    end
  end
end
