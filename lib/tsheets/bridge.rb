require 'json'

class TSheets::Bridge
  attr_accessor :config

  def initialize(config)
    self.config = config
  end

  def auth_options
    { "Authorization" => "Bearer #{self.config.access_token}" }
  end

  def items_from_data(data, name, is_singleton, mode)
    if mode == :report
      objects = data["results"].values.first
      return objects == [] ? [] : objects.values
    end

    if is_singleton || !data['results'][name].is_a?(Hash)
      data['results'][name]
    else
      data['results'][name].values
    end
  end

  def next_batch(url, name, options, is_singleton = false, mode = :list)
    method = mode == :list ? :get : :post
    options = { data: (options.empty? ? 0 : options) } if mode == :report
    response = self.config.adapter.send method, "#{self.config.base_url}#{url}", options, self.auth_options
    data = JSON.parse(response.to_str)
    if response.code == 200
      return {
        items: items_from_data(data, name, is_singleton, mode),
        has_more: data['more'] == true,
        supplemental: (
          if data['supplemental_data']
            data['supplemental_data'].inject({}) do |sum, parts|
              sum
              key, value = parts
              sum[key.to_sym] = value.values
              sum
            end
        else
          {}
        end
        )
      }
    else
      raise TSheets::ExpectationFailedError, data.fetch("error", {}).fetch("message", "").gsub('Expectation Failed: ', '')
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

  def delete(url, id)
    response = self.config.adapter.delete "#{self.config.base_url}#{url}", { ids: [ id ] }, self.auth_options
    TSheets::Result.new response.code, response.to_str
  end

end
