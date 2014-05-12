require 'spec_helper'

describe JPath::Parser do
  
  it "parses child" do
    JPath.parse("store").to_s.should               == "child::store"
    JPath.parse("child::store").to_s.should        == "child::store"
    JPath.parse("*").to_s.should                   == "child::*"
    JPath.parse("./store").to_s.should             == "child::store"
    JPath.parse("/store").to_s.should              == "/child::store"
    JPath.parse("/child::store").to_s.should       == "/child::store"
    JPath.parse("/*").to_s.should                  == "/child::*"
    JPath.parse("/store/book").to_s.should         == "/child::store/child::book"
  end
  
  it "parses descendant" do
    JPath.parse("//book").to_s.should              == "descendant::book"
    JPath.parse("descendant::book").to_s.should    == "descendant::book"
    JPath.parse("//*").to_s.should                 == "descendant::*"
    JPath.parse(".//book").to_s.should             == "descendant::book"
    JPath.parse("/descendant::book").to_s.should   == "/descendant::book"
    JPath.parse("/*").to_s.should                  == "/child::*"
    JPath.parse("/store//price").to_s.should       == "/child::store/descendant::price"
  end
  
  it "parses attributes" do
    JPath.parse('book[1]').to_s.should             == 'child::book[position()=1]'
    JPath.parse('book[last()]').to_s.should        == 'child::book[position()=last()]'
    JPath.parse('book[position()>1]').to_s.should  == 'child::book[position()>1]'
    JPath.parse('book[@price]').to_s.should        == 'child::book[attribute::price]'
    JPath.parse('book[@price="8.95"]').to_s.should == 'child::book[attribute::price="8.95"]'
    JPath.parse('book[@price=8.95]').to_s.should   == 'child::book[attribute::price=8.95]'
    JPath.parse('book[@price<8.95]').to_s.should   == 'child::book[attribute::price<8.95]'
  end
  
end