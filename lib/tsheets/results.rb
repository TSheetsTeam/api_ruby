class TSheets::Results
  include Enumerable

  attr_accessor :url, :options, :model, :cache,
    :bridge, :name, :index, :loaded, :has_more

  alias_method :all, :to_a

  def initialize(url, options, model, bridge, cache)
    self.url = url
    self.options = options
    self.model = model
    self.name = "#{TSheets::Helpers.class_to_endpoint(model)}s"
    self.index = -1
    self.loaded = []
    self.bridge = bridge
    self.cache = cache
    self.has_more = true
  end

  def each
    return enum_for(:each) unless block_given?
    while (self.index += 1) < self.loaded.count || (self.has_more && load_next_batch)
      yield self.loaded[self.index]
    end
    self.index = -1
  end

  def load_next_batch
    response = self.bridge.next_batch(self.url, self.name, self.options)
    batch = response[:items]
    self.has_more = response[:has_more]
    self.loaded += batch.map { |o| self.model.from_raw(o, self.cache, response[:supplemental] || {}) }
    batch != []
  end

end
