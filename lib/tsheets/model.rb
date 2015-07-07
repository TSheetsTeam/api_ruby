class TSheets::Model
  attr_accessor :cache

  @@_models ||= {}
  @@_accessors ||= {}

  def initialize(cache)
    self.cache = cache
  end

  def self.field fname, type
    send :attr_accessor, fname

    @@_accessors[name] ||= []
    @@_accessors[name].push name: fname.to_sym, type: type
  end

  def self.model fname, options
    send :attr_accessor, fname

    @@_models[name] ||= []
    @@_models[name].push options.merge(name: fname)
  end

  def self.type_for(model_name, field_name)
    @@_accessors[model_name].find { |a| a[:name] == field_name.to_sym }[:type]
  end

  def self.type_for_key(key)
    type_for(name, key)
  end

  def self.cast_raw(value, key, cache, type = nil)
    return nil if value.nil?
    type_symbol = type || type_for_key(key)
    if type_symbol.is_a?(Array)
      value.map { |i| cast_raw(i, key, cache, type_symbol.first) }
    else
      case type_symbol
      when :integer
        value.to_i
      when :string
        value
      when :datetime
        DateTime.parse(value) rescue nil
      when :date
        Date.parse(value) rescue nil
      when :boolean
        value == true
      else
        TSheets::Helpers.to_class(type_symbol, self).from_raw(value, cache)
      end
    end
  end

  def cast_to_raw(value, key, type = nil)
    return nil if value.nil?
    type_symbol = type || self.class.type_for_key(key)
    if type_symbol.is_a?(Array)
      value.map { |i| cast_to_raw(i, key, type_symbol.first) }
    else
      case type_symbol
      when :integer
        value
      when :string
        value
      when :datetime
        value.iso8601
      when :date
        value.strftime("%Y-%m-%d")
      when :boolean
        value
      else
        value.to_raw
      end
    end
  end

  def self.from_raw(hash, cache, supplemental = {})
    instance = hash.inject self.new(cache) do |o, p|
      k, v = p
      o.send "#{k}=", cast_raw(v, k, cache)
      o
    end
    models.each do |model_def|
      instance.send "#{model_def[:name]}=", resolve_supplemental(instance, model_def, cache, supplemental)
    end
    instance
  end

  def to_raw
    self.attributes.inject({}) do |obj, pair|
      k, v = pair
      obj[k.to_s] = cast_to_raw(v, k)
      obj
    end
  end

  def self.models
    @@_models[name] || []
  end

  def self.find_raw_supplemental(instance, model_def, supplemental)
    return if supplemental.empty?
    linked_id = instance.send model_def[:foreign]
    supplemental["#{model_def[:type]}s".to_sym].find do |raw|
      linked_id == cast_raw(raw[model_def[:primary].to_s], model_def[:primary], type_for(TSheets::Helpers.to_class_name(model_def[:type]), model_def[:primary]))
    end
  end

  def self.resolve_supplemental(instance, model_def, cache, supplemental)
    raw_supplemental = find_raw_supplemental(instance, model_def, supplemental)
    if raw_supplemental
      instance.cache.store model_def, TSheets::Helpers.to_class(model_def[:type].to_s).from_raw(raw_supplemental, cache)
    else
      instance.cache.resolve model_def, instance
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
