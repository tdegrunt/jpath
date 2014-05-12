require 'spec_helper'

describe JPath::Item do
  
  let(:item) do
    JPath::Item.new(HASH)
  end
  
  context "#[]" do
    it "returns smth" do
      item["store.book.0"].should == HASH["store"]["book"][0]
    end
  end

  context "#parent" do
    it "returns smth" do
      item.parent("store.book.0").to_s.should == "store"
    end
    it "returns smth" do
      item.parent("store.book.0.title").to_s.should == "store.book.0"
    end
  end

  context "#ancestors" do
    it "returns smth" do
      item.ancestors("store.book.0").map(&:to_s).should == ["store", ""]
    end
    it "returns smth" do
      item.ancestors("store.book.0.title").map(&:to_s).should == ["store.book.0", "store", ""]
    end
  end
  
  context "#children" do
    it "returns smth" do
      item.children("store").map(&:to_s).should == ["store.book.0", "store.book.1", "store.book.2", "store.book.3", "store.bicycle"]
    end
    it "returns smth" do
      item.children("store.bicycle").map(&:to_s).should == ["store.bicycle.color", "store.bicycle.price"]
    end
  end

  context "#attributes" do
    it "returns smth" do
      item.attributes("store").map(&:to_s).should == []
    end
    it "returns smth" do
      item.attributes("store.bicycle").map(&:to_s).should == ["store.bicycle.color", "store.bicycle.price"]
    end
  end
  
  context "#descendants" do
    it "returns smth" do
      item.descendants("store.bicycle").map(&:to_s).should == ["store.bicycle.color", "store.bicycle.price"]
    end
    it "returns smth" do
      item.descendants("store").map(&:to_s).should == ["store.book.0", "store.book.0.category", "store.book.0.author", "store.book.0.title", "store.book.0.price", "store.book.1", "store.book.1.category.0", "store.book.1.author", "store.book.1.title", "store.book.1.price", "store.book.2", "store.book.2.category", "store.book.2.author", "store.book.2.title", "store.book.2.isbn", "store.book.2.price", "store.book.3", "store.book.3.category", "store.book.3.author", "store.book.3.title", "store.book.3.isbn", "store.book.3.price", "store.bicycle", "store.bicycle.color", "store.bicycle.price"]
    end
  end
  
  context "#following" do
    it "returns smth" do
      item.following("store.book.0").map(&:to_s).should == ["store.book.1", "store.book.2", "store.book.3", "store.bicycle"]
    end
    it "returns smth" do
      item.following("store.book.0.author").map(&:to_s).should == ["store.book.0.title", "store.book.0.price"]
    end
    it "returns smth" do
      item.following("store.bicycle").map(&:to_s).should == []
    end
  end

  context "#preceding" do
    it "returns smth" do
      item.preceding("store.book.2").map(&:to_s).should == ["store.book.0", "store.book.1"]
    end
    it "returns smth" do
      item.preceding("store.book.0.author").map(&:to_s).should == ["store.book.0.category"]
    end
    it "returns smth" do
      item.preceding("store.bicycle").map(&:to_s).should == ["store.book.0", "store.book.1", "store.book.2", "store.book.3"]
    end
  end
  
end