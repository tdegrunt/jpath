module JPath
  module Parser
    class Step
      
      attr_reader :name
      
      attr_reader :predicates
      
      def initialize(name)
        @name = name
        @predicates = []
      end
      
      def wildcard?
        name == '*'
      end
      
      def +(other)
        other.add(self)
      end
      
      def <<(predicate)
        @predicates << predicate
      end
      
      def to_s
        "%s::%s%s" % [axis, name, predicates.map(&:to_s).join("")]
      end
      
    end
    class Self < Step
      
      def initialize
        super(nil)
      end

      def to_s
        "self"
      end

    end
    class Root < Step
      
      def initialize
        super(nil)
      end
      
      def from(item, context)
        [context]
      end
      
      def to_s
        ""
      end

    end
    class Attribute < Step
      
      def boolean?
        false
      end
      
      def value(item, context, index, size)
        value = item[context + name]
        if value.nil?
          return nil
        end
        if value =~ /\A\d+\.\d+\z/
          value.to_f
        elsif value =~ /\A\d+\z/
          value.to_i
        else
          value
        end
      end
      
      def axis
        "attribute"
      end

    end
    class Node < Step
      
      def select(item, list)
        select_by_predicates item, select_by_name(list)
      end
      
      private
      
      def select_by_name(list)
        wildcard? ? list : list.select { |child| child.name == @name }
      end
      
      def select_by_predicates(item, list)
        predicates.each_with_index { |p| list = select_by_predicate(item, list, p) }; list
      end
      
      def select_by_predicate(item, list, p)
        list.select.with_index { |context, index| p.true?(item, context, index + 1, list.size) }
      end
      
    end
    class Child < Node
      
      def from(item, context)
        return select item, item.children(context)
      end
      
      def axis
        "child"
      end
      
    end
    class Descendant < Node
      
      def from(item, context)
        return select item, item.descendants(context)
      end
      
      def axis
        "descendant"
      end
      
    end
  end
end
