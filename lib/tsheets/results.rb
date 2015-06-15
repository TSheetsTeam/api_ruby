require 'rest-client'
require 'json'

class TSheets::Results
  include Enumerable

  def initialize(url, options, headers, model)
    @_url = url
    @_options = options
    @_headers = headers
    @_model = model
    @_name = TSheets::Helpers.class_to_endpoint model
    @_index = -1
    @_loaded = []
  end

  def each
    while @_index < @_loaded.count || load_next_batch
      yield @_loaded[@_index += 1]
    end
  end

  def load_next_batch
    response = RestClient.get @_url, @_headers.merge({ params: @_options })
    # TODO: Implement handling of the supplemental data
    if response.code == 200
      resource = JSON.parse(response.to_str)
      @_loaded << resource[@_name].map do |k, res|
        @_model.new res
      end
    else
      false
    end
  end

end
