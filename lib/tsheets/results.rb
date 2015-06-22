class TSheets::Results
  attr_accessor :url, :options, :model,
    :bridge, :name, :index, :loaded

  def initialize(url, options, model, bridge)
    self.url = url
    self.options = options
    self.model = model
    self.name = TSheets::Helpers.class_to_endpoint model
    self.index = -1
    self.loaded = []
    self.bridge = bridge
  end

  def each
    return enum_for(:each) unless block_given?
    while (self.index += 1) < self.loaded.count || load_next_batch
      yield self.loaded[self.index]
    end
    self.index = -1
  end

  def next
    each.next
  end

  def load_next_batch
    batch = self.bridge.next_batch(self.url, self.options)
    self.loaded += batch.map { |o| self.model.from_raw(o) }
    batch != []
  end

end
