require 'date'

class TSheets::Repository
  attr_accessor :bridge, :cache

  @@allowed_classes_for_spec = {
    boolean: [ ::TrueClass, ::FalseClass ],
    integer: [ ::Fixnum ],
    string:  [ ::String, ::Symbol ],
    date:    [ ::Date ],
    datetime: [ ::DateTime ]
  }

  def initialize(bridge, cache)
    raise ArgumentError, "Expected initialized instance of TSheets::Bridge when initializing the repository" if !bridge.is_a?(TSheets::Bridge)
    raise ArgumentError, "Expected initialized instance of TSheets::SupplementalCache when initializing the repository" if !cache.is_a?(TSheets::SupplementalCache)
    self.bridge = bridge
    self.cache = cache
  end

  def filters
    @@filters
  end

  def with_action(action, &block)
    if self.actions.include? action
      block.call
    else
      raise TSheets::MethodNotAvailableError, "Method '#{caller[0].split("`").pop.gsub("'", "")}' not available on #{self.class.name} due to lack of the :#{action} in available actions list. Actions list: #{self.actions}"
    end
  end

  def where(options)
    with_action :list do
      TSheets::Results.new url, self.validated_options(options), self, self.bridge, self.cache, self.is_singleton
    end
  end

  def report(options)
    with_action :report do
      TSheets::Results.new url, self.validated_options(options), self, self.bridge, self.cache, self.is_singleton, :report
    end
  end

  def insert(entity)
    with_action :add do
      self.bridge.insert(url, entity.to_raw(:add))
    end
  end

  def update(entity)
    with_action :edit do
      self.bridge.update(url, entity.to_raw(:edit))
    end
  end

  def delete(entity)
    with_action :delete do
      self.bridge.delete(url, entity.id)
    end
  end

  def all
    self.where({}).all
  end

  def first
    self.all.first
  end

  def validated_options(options)
    -> {
      options.each do |name, value|
        validate_option name, value
      end
    }.call && options
  end

  def validate_option(name, value)
    type_spec = @@filters[name]
    raise TSheets::FilterNotAvailableError, "Unknown filter for #{self.class} - #{name}" if type_spec.nil?
    if type_spec.is_a?(Array)
      if !value.is_a?(Array)
        raise TSheets::FilterValueInvalidError, "Expected the value for the #{name} filter to be an array"
      else
        if value.any? { |v| !self.matches_type_spec?(v.class, type_spec.first) }
          raise TSheets::FilterValueInvalidError, "Expected all values of an array for the #{name} filter to match the type spec: :#{type_spec.first}"
        end
      end
    else
      if !self.matches_type_spec?(value.class, type_spec)
        raise TSheets::FilterValueInvalidError, "Expected the value for the #{name} filter to match the type spec: :#{type_spec}"
      end
    end
  end

  def matches_type_spec?(klass, single_type_spec)
    arr = @@allowed_classes_for_spec[single_type_spec]
    arr ? arr.include?(klass) : TSheets::Helpers.to_class(single_type_spec) == klass
  end

  class << self
    def url address
      define_method :url do
        address
      end
    end

    def model klass, options = {}
      define_method :model do
        klass
      end
      define_method :is_singleton do
        options.fetch(:singleton, false)
      end
    end

    def actions *list
      define_method :actions do
        list
      end
    end

    def filter fname, type
      @@filters ||= {}
      @@filters[fname] = type
    end

    def filters
      @@filters
    end

    def inherited(child)
      @@_descendants ||= []
      @@_descendants.push child
    end

    def classes
      @@_descendants
    end
  end
end
