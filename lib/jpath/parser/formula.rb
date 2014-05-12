module JPath
  module Parser
    class Predicate
      
      attr_reader :expression
      
      def initialize(expression)
        @expression = expression
      end
      
      def true?(*args)
        expression.true?(*args)
      end
      
      def to_s
        "[%s]" % expression
      end
      
    end
    class Operator
      
      attr_reader :char
      
      attr_reader :parts
      
      def initialize(char)
        @char  = char
        @parts = []
      end
      
      def boolean?
        false
      end
      
      def +(other)
        add(other)
      end
      
      def add(other)
        @parts << other
        if parts.size < 2
          self
        else
          Formula.new(char, parts)
        end
      end
      
      def to_s
        char.to_s
      end
      
    end
    class Formula
      
      attr_reader :parts
      
      attr_reader :type
      
      def initialize(type, *parts)
        @type  = type
        @parts = parts.flatten
      end
      
      def true?(*args)
        f = first.value(*args)
        s = second.value(*args)
        if requires_boolean?
          unless f === true or f === false
            return false
          end
          unless s === true or s === false
            return false
          end
        else
          unless f.is_a?(Numeric)
            return false
          end
          unless s.is_a?(Numeric)
            return false
          end
        end
        case type
        when "+"
          f + s
        when "-"
          f - s
        when "*"
          f * s
        when "/"
          f / s
        when ">"
          f > s
        when "<"
          f < s
        when "="
          f == s
        when "and"
          f && s
        when "or"
          f || s
        else
          raise "Invalid formula type: %s" % type
        end
      end
      
      def first
        parts[0]
      end
      
      def second
        parts[1]
      end
      
      def requires_boolean?
        %w(and or).include?(type)
      end
      
      def boolean?
        %w(> < = and or).include?(type)
      end
      
      def to_predicate
        Predicate.new(self)
      end
      
      def to_s
        "%s%s%s" % [first, type, second]
      end
      
    end
    class Contains
      
      attr_reader :item
      
      def initialize(item)
        @item = item
      end
      
      def true?(item, context, index, size)
        item.children(context).map(&:name).include?(@item.name)
      end
      
      def boolean?
        true
      end
      
      def to_predicate
        Predicate.new(self)
      end
      
      def to_s
        item.to_s
      end
      
    end
    class Position
      
      def to_s
        "position()"
      end
      
      def value(hash, pointer, index, size)
        index
      end
      
      def +(other)
        other.add(self)
      end
      
    end
    class Last
      
      def value(hash, pointer, index, size)
        size
      end
      
      def to_s
        "last()"
      end
      
    end
    class Literal
      
      attr_reader :string
      
      def initialize(string)
        @string = string
      end
      
      def value(*args)
        string
      end
      
      def boolean?
        false
      end
      
      def to_s
        string.inspect
      end
      
    end
    class Number
      
      attr_reader :number
      
      def initialize(number)
        @number = number
      end
      
      def value(*args)
        number
      end
      
      def boolean?
        false
      end
      
      def to_s
        number.to_s
      end
      
    end
  end
end
