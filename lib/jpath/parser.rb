module JPath
  module Parser
    
    def self.path(s)
      unless s.is_a?(StringScanner)
        s = StringScanner.new(s)
      end
      Path.new do |path|
        each_step(s) do |step|
          path << step
        end
      end
    end
    
    def self.predicates(s)
      enum_for(:each_predicate, s).to_a
    end
    
    def self.steps(s)
      enum_for(:each_step, s).to_a
    end
    
    def self.expressions(s)
      enum_for(:each_expression, s).to_a
    end
    
    private
    
    def self.next_expression(s)
      if s.scan /position\(\)/
        return Position.new
      end
      if s.scan /(\d+\.\d+)/
        return Number.new(s[1].to_f)
      end
      if s.scan /(\d+)/
        return Number.new(s[1].to_i)
      end
      if s.scan /@([\w*]+)/
        return Attribute.new(s[1])
      end
      if s.scan /\=/
        return Operator.new("=")
      end
      if s.scan /</
        return Operator.new("<")
      end
      if s.scan />/
        return Operator.new(">")
      end
      if s.scan /"([^"]+)"/
        return Literal.new(s[1])
      end
    end
    
    def self.each_expression(s)
      until s.eos?
        obj = next_expression(s)
        break if obj.nil?
        yield obj
      end
    end
    
    def self.next_predicate(s)
      if s.scan /\[(\d+)\]/
        return Formula.new("=", Position.new, Number.new(s[1].to_i)).to_predicate
      end
      if s.scan /\[last\(\)\]/
        return Formula.new("=", Position.new, Last.new).to_predicate
      end
      if s.scan /\[@?([\w*]+)\]/
        return Predicate.new(Contains.new(Attribute.new(s[1])))
      end
      unless s.scan(/\[/)
        return
      end
      exp = expressions(s).inject do |result, expression|
        result + expression
      end
      if exp.nil? || !exp.boolean?
        raise "Invalid predicate: %s" % s.rest.inspect 
      end
      unless s.scan(/\]/)
        raise "Invalid predicate: %s" % s.rest.inspect 
      end
      Predicate.new(exp)
    end
    
    def self.each_predicate(s)
      until s.eos?
        obj = next_predicate(s)
        break if obj.nil?
        yield obj
      end
    end
    
    def self.next_step(s)
      if s.scan /\.?\/\/([\w*]+)/
        return Descendant.new(s[1])
      elsif s.scan /descendant::([\w*]+)/
        return Descendant.new(s[1])
      elsif s.scan /child::([\w*]+)/
        return Child.new(s[1])
      elsif s.scan /([\w*]+)/
        return Child.new(s[1])
      elsif s.scan /.\//
        return Self.new
      elsif s.bol? && s.scan(/\//)
        return Root.new
      end
    end
    
    def self.each_step(s)
      until s.eos?
        obj = next_step(s)
        break if obj.nil?
        each_predicate(s) do |p|
          obj << p
        end
        yield obj
        unless s.match?(/\/\//)
          s.scan /\//
        end
      end
    end
      
  end
end