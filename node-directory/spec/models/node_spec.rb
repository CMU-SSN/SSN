require 'spec_helper'

describe Node do
  before(:each) do
    @attr = {
      :name => "Node Name",
      :latitude => 10,
      :longitude => 20,
      :link => "ssn.com/signup",
      :uid => "UID",
      :checkin => DateTime.now 
    }
  end

  it "should be successful with all the attributes" do
    Node.create!(@attr)
  end

  it "should need a name" do
    new_node = Node.new(@attr.merge(:name => ""))
    new_node.should_not be_valid
  end

  it "should need a latitude" do
    new_node = Node.new(@attr.merge(:latitude => nil))
    new_node.should_not be_valid
  end

  it "should need a longitude" do
    new_node = Node.new(@attr.merge(:longitude => nil))
    new_node.should_not be_valid
  end

  it "should need a link" do
    new_node = Node.new(@attr.merge(:link => ""))
    new_node.should_not be_valid
  end

  it "should need a uid" do
    new_node = Node.new(@attr.merge(:uid => ""))
    new_node.should_not be_valid
  end

  it "should need a checkin" do
    new_node = Node.new(@attr.merge(:checkin => nil))
    new_node.should_not be_valid
  end
end
