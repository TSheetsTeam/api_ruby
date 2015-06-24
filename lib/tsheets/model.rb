class TSheets::Model
  def self.field fname, type
    send :attr_accessor, fname

    @@_accessors ||= {}
    @@_accessors[name] ||= []
    @@_accessors[name].push name: fname.to_sym, type: type
  end

  def self.type_for_key(key)
    @@_accessors[name].find { |a| a[:name] == key.to_sym }[:type]
  end

  def self.cast_raw(value, key, type = nil)
    type_symbol = type || type_for_key(key)
    if type_symbol.is_a?(Array)
      value.map { |i| cast_raw(i, key, type_symbol.first) }
    else
      case type_symbol
      when :integer
        value.to_i
      when :string
        value
      when :datetime
        DateTime.parse(value)
      when :date
        Date.parse(value)
      when :boolean
        value == true
      end
    end
  end

  def self.from_raw(hash)
    hash.inject self.new do |o, p|
      k, v = p
      o.send "#{k}=", cast_raw(v, k)
      o
    end
  end

  def attribute_names
    @@_accessors[self.class.name]
  end

  def attributes
    @@_accessors[self.class.name].inject({}) do |sum, attr|
      sum[attr[:name]] = self.send(attr[:name])
      sum
    end
  end

  def inspect
    "<#{self.class.name} #{self.attributes.inspect.gsub(/(\{|\})/, '')}>"
  end
end
