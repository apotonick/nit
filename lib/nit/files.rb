module Nit
  class Files < Array
    def initialize(arr=[], indexer=IntegerIndexer) # FIXME: make 2nd arg obligatory.
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

       # decorator:
      def list(indexes)
        indexes.collect { |i| self[i] }.join(" ")
      end
    end
    include PublicMethods

  private

    module IntegerIndexer
    end

    module CharIndexer
      def [](char)
        index = map.index(char)
        super(index)
      end

      def evaluate(chars)
        super(split(chars)) # "nit commit abc"
      end

      def index(file)
        map[super]
      end

      def list(indexes)
        super(split(indexes))
      end

    private
      def map
        ("a".."z").collect(&:to_s)
      end

      def split(chars)
        return chars unless chars.find { |c| c.length > 1 } # DISCUSS: what if "> aa bcd xx" where xx is actually an index?
        chars.first.split("")
      end
    end
  end
end