class TSheets::Helpers
  class << self 
    def to_class_name(name)
      name.split('_').map { |s| s.capitalize }.join
    end

    def to_class(name)
      to_class_name(name).constantize
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
