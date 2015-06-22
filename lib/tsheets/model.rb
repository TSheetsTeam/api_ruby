class TSheets::Model
  def self.field fname, type
    send :attr_accessor, fname

    @@_accessors ||= {}
    @@_accessors[name] ||= []
    @@_accessors[name].push fname
  end

  def self.from_raw(hash)
    hash.inject self.new do |o, p|
      k, v = p
      o.send "#{k}=", v
      o
    end
  end

  def attribute_names
    @@_accessors[self.class.name]
  end

  def attributes
    @@_accessors[self.class.name].inject({}) do |sum, attr|
      sum[attr] = self.send(attr)
      sum
    end
  end

  def inspect
    "<#{self.class.name} #{self.attributes.inspect.gsub(/(\{|\})/, '')}>"
  end
end
