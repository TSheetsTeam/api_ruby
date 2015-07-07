require 'rest-client'

class TSheets::RestAdapter < TSheets::Adapter
  class << self
    def get(url, options)
      RestClient.get url, options
    end

    def post(url, data, options)
      RestClient.post url, data.to_json, options
    rescue => e
      e.response
    end

    def put(url, data, options)
      RestClient.put url, data.to_json, options
    rescue => e
      e.response
    end

    def delete(url, data, options)
      RestClient.delete url, data.to_json, options
    rescue => e
      e.response
    end
  end
end
