module JPath
  module Parser
    class Union
      
      def initialize(*paths)
        @paths = paths
      end
      
      def to_s
        @paths.map(&:to_s).join("|")
      end
      
    end
    class Path
      
      attr_reader :steps
      
      def initialize
        @steps = []
        if block_given?
          yield self
        end
      end
      
      def from(item)
        unless item.is_a?(Item)
          item = Item.new(item)
        end
        list = [Pointer.new]
        steps.each do |step|
          list = list.map { |node|
            step.from(item, node).to_a
          }.flatten
        end
        list = list.map do |pointer|
          item[pointer]
        end
        list
      end
      
      def <<(step)
        unless step.is_a?(Self)
          @steps << step
        end
      end
      
      def to_s
        @steps.join("/")
      end
    
    end
  end
end