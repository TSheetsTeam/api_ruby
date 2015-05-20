class TSheets::Repo
  def initialize(bridge)
    @_bridge = bridge
  end

  class << self
    def url address
    end

    def model klass
    end

    def actions *list
    end

    def filter fname, type
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
