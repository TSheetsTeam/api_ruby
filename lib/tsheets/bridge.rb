require 'json'

class TSheets::Bridge
  attr_accessor :config

  def initialize(config)
    self.config = config
  end

  def auth_options
    { "Authorization" => "Bearer #{self.config.access_token}" }
  end

  def next_batch(url, name, options)
    response = self.config.adapter.get "#{self.config.base_url}#{url}", self.auth_options.merge(params: options)
    if response.code == 200
      data = JSON.parse(response.to_str)
      return {
        items: data['results'][name].values,
        has_more: data['more'] == true,
        supplemental: data['supplemental_data'] ? data['supplemental_data'].inject({}) do |sum, parts|
          sum
          key, value = parts
          sum[key.to_sym] = value.values
          sum
        end : {}
      }
    else
      {
        items: [],
        has_more: false
      }
    end
  end

  def insert(url, raw_entity)
    response = self.config.adapter.post "#{self.config.base_url}#{url}", { 'data' => [ raw_entity ] }, self.auth_options
    TSheets::Result.new response.code, response.to_str
  end

  def update(url, raw_entity)
    response = self.config.adapter.put "#{self.config.base_url}#{url}", { 'data' => [ raw_entity ] }, self.auth_options
    TSheets::Result.new response.code, response.to_str
  end

end
