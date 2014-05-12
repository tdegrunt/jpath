require 'spec_helper'

describe JPath do
  
  context "/store/book/author" do
    it "returns the authors of all books in the store" do
      JPath.find(HASH, "/store/book/author").should == ["Nigel Rees", "Evelyn Waugh", "Herman Melville", "J. R. R. Tolkien"]
    end
  end

  context "//author" do
    it "returns all authors" do
      JPath.find(HASH, "//author").should == ["Nigel Rees", "Evelyn Waugh", "Herman Melville", "J. R. R. Tolkien"]
    end
  end
  
  context "/store/*" do
    it "all things in store, which are some books and a red bicycle" do
      JPath.find(HASH, "/store/*").should == [HASH["store"]["book"][0], HASH["store"]["book"][1], HASH["store"]["book"][2], HASH["store"]["book"][3], HASH["store"]["bicycle"]]
    end
  end

  context "/store//price" do
    it "returns the price of everything in the store" do
      JPath.find(HASH, "/store//price").should == [8.95, 12.99, 8.95, 22.99, 19.95]
    end
  end
  
  context "//book[3]" do
    it "returns the third book" do
      JPath.find(HASH, "//book[3]").should == [HASH["store"]["book"][2]]
    end
  end
  
  context "//book[last()]" do
    it "the last book in order" do
      JPath.find(HASH, "//book[last()]").should == [HASH["store"]["book"][3]]
    end
  end
  
  context "//book[position()<3]" do
    it "returns the first two books" do
      JPath.find(HASH, "//book[position()<3]").should == [HASH["store"]["book"][0], HASH["store"]["book"][1]]
    end
  end
  
  context "//book[isbn]" do
    it "returns all books with isbn number" do
      JPath.find(HASH, "//book[isbn]").should == [HASH["store"]["book"][2], HASH["store"]["book"][3]]
    end
  end
  
  context "//book[@price<10]" do
    it "returns all books cheapier than 10" do
      JPath.find(HASH, "//book[@price<10]").should == [HASH["store"]["book"][0], HASH["store"]["book"][2]]
    end
  end
  
end