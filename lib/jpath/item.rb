module JPath
  class Item
    
    def initialize(hash)
      @hash = hash
    end
    
    def [](pointer)
      result = @hash
      if pointer.is_a?(String)
        pointer = Pointer.parse(pointer)
      end
      pointer.each do |key|
        unless result.is_a?(Array) or result.is_a?(Hash)
          return nil
        end
        if result.is_a?(Array) && !key.is_a?(Numeric)
          return nil
        end
        result = result[key]
      end
      result
    end
    
    def parent(pointer)
      if pointer.is_a?(String)
        pointer = Pointer.parse(pointer)
      end
      if pointer.top?
        return nil
      end
      if pointer.index?
        pointer.grandparent
      else
        pointer.parent
      end
    end
    
    def ancestors(pointer)
      if pointer.is_a?(String)
        pointer = Pointer.parse(pointer)
      end
      obj = parent(pointer)
      if obj.nil?
        []
      else
        [obj, ancestors(obj)].flatten
      end
    end
    
    def attributes(pointer)
      enum_for(:each_attribute, pointer)
    end
    
    def children(pointer)
      enum_for(:each_child, pointer)
    end
    
    def descendants(pointer)
      enum_for(:each_descendant, pointer)
    end
    
    def following(pointer)
      enum_for(:each_following, pointer)
    end
    
    def preceding(pointer)
      enum_for(:each_preceding, pointer)
    end
    
    private
    
    def each_attribute(pointer)
      children(pointer).select do |child|
        unless self[child].is_a?(Hash)
          yield child
        end
      end
    end
    
    def each_child(pointer, &block)
      if pointer.is_a?(String)
        pointer = Pointer.parse(pointer)
      end
      obj = self[pointer]
      if obj.is_a?(Hash)
        obj.each do |key, value|
          if value.is_a?(Array)
            each_child(pointer + key, &block)
          else
            yield pointer + key
          end
        end
      end
      if obj.is_a?(Array)
        obj.each_with_index do |item, index|
          yield pointer + index
        end
      end
    end
    
    def each_descendant(pointer)
      children(pointer).each do |p1|
        yield p1
        each_descendant(p1) do |p2|
          yield p2
        end
      end
    end
    
    def each_following(pointer)
      flag   = false
      parent = parent(pointer)
      each_child(parent) do |child|
        if flag
          yield child
        end
        if child == pointer
          flag = true
        end
      end
    end

    def each_preceding(pointer)
      flag   = true
      parent = parent(pointer)
      each_child(parent) do |child|
        if child == pointer
          flag = false
        end
        if flag
          yield child
        end
      end
    end
    
  end
end
