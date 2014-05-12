module JPath
  class Pointer
    
    def self.parse(string)
      new string.split(".").map { |str|
        str =~ /\A\d+\z/ ? str.to_i : str
      }.to_a
    end
    
    def initialize(*ary)
      @ary = ary.flatten
    end
    
    def ==(other)
      to_s == other.to_s
    end
    
    def +(string)
      self.class.new(@ary + [string])
    end
    
    def each(&block)
      @ary.each(&block)
    end
    
    def name
      index? ? (parent.nil? ? nil : parent.name) : @ary.last
    end
    
    def grandparent
      parent.nil? ? nil : parent.parent
    end
    
    def parent
      top? ? nil : self.class.new(without_last)
    end
    
    def size
      @ary.size
    end
    
    def index?
      @ary.last.is_a?(Integer)
    end
    
    def top?
      @ary.empty? or top_index?
    end
    
    def to_s
      @ary.join(".")
    end
    
    private
    
    def top_index?
      index? && size == 1
    end
    
    def without_last
      @ary[0...-1]
    end
    
  end
end