require 'rest-client'
require 'json'

class TSheets::Bridge
  attr_accessor :config

  def initialize(config)
    self.config = config
  end

  def access_token
    self.config[:access_token]
  end

  def base_url
    self.config[:base_url] || "https://rest.tsheets.com/api/v1"
  end

  def next_batch(url, options)
    response = RestClient.get "#{base_url}#{url}", { Authorization: "Bearer: #{self.access_token}", params: options }
    if response.code == 200
      JSON.parse(response.to_str)
    else
      []
    end
  end

end
