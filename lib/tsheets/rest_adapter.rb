require "typhoeus"

class TSheets::RestAdapter < TSheets::Adapter
  class << self
    def get(url, params, headers)
      puts "GET #{url} (#{headers.inspect}) - #{params.inspect}" if Typhoeus::Config.verbose
      TSheets::HttpResponse.new Typhoeus.get(url, params: params, headers: headers)
    end

    def post(url, data, options)
      puts "POST #{url} (#{options.inspect}) - #{data.inspect}" if Typhoeus::Config.verbose
      TSheets::HttpResponse.new Typhoeus.post(url, body: data, headers: options)
    end

    def put(url, data, options)
      puts "PUT #{url} (#{options.inspect}) - #{data.inspect}" if Typhoeus::Config.verbose
      TSheets::HttpResponse.new Typhoeus.put(url, body: data, headers: options)
    end

    def delete(url, data, options)
      puts "DELETE #{url} (#{options.inspect}) - #{data.inspect}" if Typhoeus::Config.verbose
      TSheets::HttpResponse.new Typhoeus.delete(url, body: data, headers: options)
    end
  end
end
