require 'rest-client'

class TSheets::RestAdapter < TSheets::Adapter
  class << self
    def get(url, options)
      RestClient.get url, options
    end

    def post(url, data, options)
      RestClient.post url, data, options
    end

    def put(url, data, options)
      RestClient.put url, data, options
    end

    def delete(url, data, options)
      RestClient.delete url, data, options
    end
  end
end
