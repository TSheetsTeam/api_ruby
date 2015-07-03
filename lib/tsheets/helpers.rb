class TSheets::Helpers
  class << self 
    def to_class_name(name, scoping_class = nil)
      class_name = name.to_s.split('_').map { |s| s.capitalize }.join
      module_part = scoping_class.nil? ? nil : scoping_class.name.split("::").reverse.drop(1).reverse.join("::")
      [ module_part, class_name ].reject { |i| i.nil? || i.empty? }.join "::"
    end

    def class_from_string(str)
      str.split('::').inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end

    def to_class(name, scoping_class = nil)
      class_from_string to_class_name(name, scoping_class)
    end

    def class_to_endpoint(klass)
      klass.name.split('::').last.
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
  end
end
