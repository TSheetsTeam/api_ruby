require 'rest-client'
require 'json'

class TSheets::Bridge
  attr_accessor :config

  def initialize(config)
    self.config = config
  end

  def next_batch(url, options)
    response = RestClient.get "#{self.config.base_url}#{url}", { Authorization: "Bearer: #{self.config.access_token}", params: options }
    if response.code == 200
      JSON.parse(response.to_str)
    else
      []
    end
  end

end
