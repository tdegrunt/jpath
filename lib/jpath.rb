module JPath
  
  require 'strscan'
  require 'json'
  
  require_relative "jpath/item"
  require_relative "jpath/pointer"
  require_relative "jpath/parser"
  require_relative "jpath/parser/formula"
  require_relative "jpath/parser/step"
  require_relative "jpath/parser/path"
  
  def self.find(json, xpath)
    parse(xpath).from(json)
  end
  
  def self.parse(xpath)
    Parser.path(xpath)
  end
  
end