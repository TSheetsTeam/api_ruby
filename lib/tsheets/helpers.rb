class TSheets::Helpers
  class << self 
    def to_class_name(name)
      name.to_s.split('_').map { |s| s.capitalize }.join
    end

    def class_from_string(str)
      str.split('::').inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end

    def to_class(name)
      class_from_string to_class_name(name)
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
