class TSheets::Model
  attr_accessor :cache, :_dynamic_accessors

  @@_models ||= {}
  @@_accessors ||= {}

  def initialize(hash = nil, options = {})
    self.cache = options[:cache] || TSheets::SupplementalCache.new
    self._dynamic_accessors ||= []
    self.class.mass_assign self, hash, self.cache, {} if hash
  end

  def self.field fname, type, options = {}
    send :attr_accessor, fname

    @@_accessors[name] ||= []
    @@_accessors[name].push name: fname.to_sym, type: type, exclude: options.fetch(:exclude, [])
  end

  def self.default_field_type type
    define_singleton_method :default_field_type_given do
      type
    end
  end

  def self.default_field_type_given
    :anything
  end

  def self.model fname, options
    send :attr_accessor, fname

    @@_models[name] ||= []
    @@_models[name].push options.merge(name: fname)
  end

  def self.type_for(model_name, field_name)
    acc = (@@_accessors[model_name] || []).find do |a| 
      a[:name] == field_name.to_sym
    end
    (acc || {}).fetch(:type, default_field_type_given)
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
      when :hash
        value
      when :float
        value
      when :object
        value == "" ? {} : value
      when :anything
        value
      else
        TSheets::Helpers.to_class(type_symbol, self).from_raw(value, cache)
      end
    end
  end

  def cast_to_raw(value, key, type = nil)
    type_symbol = type || self.class.type_for_key(key)
    if type_symbol.is_a?(Array)
      value.nil? ? [] : value.map { |i| cast_to_raw(i, key, type_symbol.first) }
    else
      case type_symbol
      when :integer
        value
      when :string
        value
      when :datetime
        value.nil? ? "" : value.iso8601
      when :date
        value.nil? ? "" : value.strftime("%Y-%m-%d")
      when :boolean
        value
      when :hash
        value
      when :float
        value
      when :object
        value.empty? ? "" : value
      when :anything
        value
      else
        value.nil? ? nil : value.to_raw
      end
    end
  end

  def self.mass_assign(instance, hash, cache, supplemental = {})
    dynamic = instance._dynamic_accessors
    instance = hash.inject instance do |o, p|
      k, v = p
      casted = cast_raw(v, k, cache)
      has_key = o.attributes.keys.include? k
      if !has_key
        o.instance_variable_set "@#{k}".to_sym, casted
        dynamic << { name: k.to_sym }
        o.define_singleton_method k do
          o.instance_variable_get "@#{k}".to_sym
        end
      else
        o.send "#{k}=", casted
      end
      o
    end
    models.each do |model_def|
      instance.send "#{model_def[:name]}=", resolve_supplemental(instance, model_def, cache, supplemental)
    end
    instance._dynamic_accessors = dynamic
    instance
  end

  def self.from_raw(hash, cache, supplemental = {})
    instance = self.new nil, cache: cache
    mass_assign instance, hash, cache, supplemental
  end

  def to_raw(mode = nil)
    self.attributes(mode).inject({}) do |obj, pair|
      k, v = pair
      obj[k.to_s] = cast_to_raw(v, k)
      obj
    end.reject { |k, v| v.nil? }
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

  def allowed_for_mode(mode, attribute)
    mode.nil? || attribute[:exclude].nil? || attribute[:exclude].empty? ||
      !attribute[:exclude].include?(mode)
  end

  def attributes_for_accessors(accessors, mode = nil)
    accessors.inject({}) do |sum, attr|
      sum[attr[:name]] = self.send(attr[:name])
      sum
    end
  end

  def attributes(mode = nil)
    accessors = (@@_accessors[self.class.name] || []).select { |a| allowed_for_mode(mode, a) }
    attributes_for_accessors accessors, mode
  end

  def dynamic_attributes
    attributes_for_accessors @_dynamic_accessors
  end

  def all_attributes(mode = nil)
    attributes(mode).merge dynamic_attributes
  end

  def inspect
    "<#{self.class.name} #{self.all_attributes.inspect.gsub(/(\{|\})/, '')}>"
  end
end
