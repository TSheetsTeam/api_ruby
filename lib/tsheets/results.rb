require 'rest-client'
require 'json'

class TSheets::Results
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
    return enum_for(:each) unless block_given?
    while (@_index += 1) < @_loaded.count || load_next_batch
      yield @_loaded[@_index]
    end
  end

  def next
    each.next
  end

  def load_next_batch
    batch = next_batch
    @_loaded += batch
    batch != []
  end

  def next_batch
    response = RestClient.get @_url, @_headers.merge({ params: @_options })
    # TODO: Implement handling of the supplemental data
    if response.code == 200
      resource = JSON.parse(response.to_str)
      resource[@_name].map do |k, res|
        @_model.new res
      end
    else
      []
    end
  end

end
