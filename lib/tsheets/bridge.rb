require 'json'

class TSheets::Bridge
  attr_accessor :config

  def initialize(config)
    self.config = config
  end

  def auth_options
    { "Authorization" => "Bearer #{self.config.access_token}" }
  end

  def items_from_data(data, name, is_singleton)
    if is_singleton || !data['results'][name].is_a?(Hash)
      data['results'][name]
    else
      data['results'][name].values
    end
  end

  def next_batch(url, name, options, is_singleton = false)
    response = self.config.adapter.get "#{self.config.base_url}#{url}", options, self.auth_options
    if response.code == 200
      data = JSON.parse(response.to_str)
      # binding.pry if name == "obj_effective_settings"
      return {
        items: items_from_data(data, name, is_singleton),
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
