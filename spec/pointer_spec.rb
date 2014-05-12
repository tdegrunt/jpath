require 'spec_helper'

describe JPath::Pointer do
  
  context ".parse" do
    it "returns Pointer" do
      JPath::Pointer.parse("store.book.0.title").to_s.should == 'store.book.0.title'
    end
    it "returns Pointer" do
      JPath::Pointer.parse("").to_s.should == ''
    end
  end
  
  context "#index?" do
    it "returns false" do
      JPath::Pointer.new().should_not be_index
    end
    it "returns false" do
      JPath::Pointer.new("store", "book", 0, "title").should_not be_index
    end
    it "returns true" do
      JPath::Pointer.new(0).should be_index
    end
    it "returns true" do
      JPath::Pointer.new("store", "book", 0).should be_index
    end
  end

  context "#name" do
    it "returns nil" do
      JPath::Pointer.new().name.should be_nil
    end
    it "returns name" do
      JPath::Pointer.new("store", "book", 0, "title").name.should == 'title'
    end
    it "returns true" do
      JPath::Pointer.new("store", "book").name.should == 'book'
    end
  end
  
  context "#top?" do
    it "returns true" do
      JPath::Pointer.new().should be_top
    end
    it "returns true" do
      JPath::Pointer.new(0).should be_top
    end
    it "returns false" do
      JPath::Pointer.new("store").should_not be_top
    end
  end
  
  context "#parent" do
    it "returns nil" do
      JPath::Pointer.new(0).parent.should be_nil
    end
    it "returns root" do
      JPath::Pointer.new("store").parent.to_s.should == ""
    end
    it "returns root" do
      JPath::Pointer.new("store", "0").parent.to_s.should == 'store'
    end
  end

  context "#grandparent" do
    it "returns nil" do
      JPath::Pointer.new(0).grandparent.should be_nil
    end
    it "returns nil" do
      JPath::Pointer.new("store").grandparent.should be_nil
    end
    it "returns root" do
      JPath::Pointer.new("store", "0").grandparent.to_s.should == ""
    end
  end
  
end