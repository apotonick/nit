module Nit
  class Files < Array
    def initialize(arr=[], indexer=IntegerIndexer)
      super(arr)
      extend indexer
    end

    # we could also use a dedicated object here.
    module PublicMethods
      def [](index)
        super(index.to_i)
      end

      # Return list of file names for indexes.
      def evaluate(indexes)
        indexes.collect { |i| self[i] }
      end
    end
    include PublicMethods

    # decorator:
    def list(indexes)
      indexes.collect { |i| self[i] }.join(" ")
    end

  private

    module IntegerIndexer
    end

    module CharIndexer
      def [](char)
        index = map.index(char)
        super(index)
      end

      def evaluate(chars)
        chars = chars.first.split("") if chars.find { |c| c.length > 1 } # "nit commit abc"
        super
      end

      def index(file)
        map[super]
      end

    private
      def map
        ("a".."z").collect(&:to_s)
      end
    end
  end
end